{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.DesktopHardware = {
    config,
    lib,
    pkgs,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot = {
      initrd = {
        availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
        kernelModules = [];
      };
      loader = {
        systemd-boot.enable = true;
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
      };
      kernelModules = ["kvm-amd"];
      extraModulePackages = [];
    };

    systemd.packages = with pkgs; [lact];
    systemd.services.lactd.wantedBy = ["multi-user.target"];

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/6ad309a1-d5b2-4e0a-ac69-19bbe3706e62";
        fsType = "ext4";
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/1F72-F85A";
        fsType = "vfat";
        options = ["fmask=0077" "dmask=0077"];
      };
    };
    swapDevices = [
      {device = "/dev/disk/by-uuid/3393e562-d144-49d5-845f-f1cc30419dfa";}
    ];

    hardware = {
      cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      amdgpu.opencl.enable = true;
      graphics = {
        enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      clinfo
      rocmPackages.rpp
      rocmPackages.clr
      rocmPackages.hipcc
      rocmPackages.rocm-runtime
      rocmPackages.rocm-smi
      lact
    ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}

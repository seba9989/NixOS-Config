{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.LaptopHardware = {
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
        efi.canTouchEfiVariables = true;
      };
      kernelModules = ["kvm-amd"];
      extraModulePackages = [];
    };

    systemd.packages = with pkgs; [lact];
    systemd.services.lactd.wantedBy = ["multi-user.target"];

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/29ab5d96-b560-456f-8bb2-37091154eeee";
        fsType = "ext4";
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/9D85-C85D";
        fsType = "vfat";
        options = ["fmask=0077" "dmask=0077"];
      };
    };
    swapDevices = [
      {device = "/dev/disk/by-uuid/0bf28498-b634-4223-a2e2-2589ab3790a4";}
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

    networking.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}

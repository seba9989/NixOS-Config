{...}: {
  flake.nixosModules.HomeLabHPHardware = {
    config,
    lib,
    pkgs,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    # TODO: podmienić całość na wynik `nixos-generate-config` uruchomionego na realnym serwerze
    boot = {
      initrd = {
        availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
        kernelModules = [];
      };
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      kernelModules = [];
      extraModulePackages = [];
    };

    # TODO: podmienić UUID-y na te z realnego serwera
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/TODO-PODMIEN-UUID";
      fsType = "ext4";
    };

    networking.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}

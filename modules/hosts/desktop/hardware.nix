{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.VMHardware = {
    config,
    lib,
    pkgs,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

    boot.initrd.availableKernelModules = ["ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = ["kvm-amd"];
    boot.extraModulePackages = [];

    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/vda";
    boot.loader.grub.useOSProber = true;

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/1542c36e-7f6e-484b-aed5-15baf1a3d17e";
      fsType = "ext4";
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/db07ca24-0dc0-444d-a5fe-a598a8dd10b7";}
    ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}

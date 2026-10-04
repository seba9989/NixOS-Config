{...}: {
  flake.nixosModules.openrgb = {pkgs, ...}: {
    # RGB control for motherboard headers (case fans/strips), RAM, peripherals.
    # Loads i2c-dev + i2c-piix4 (AMD SMBus) and installs OpenRGB udev rules.
    services.hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
      motherboard = "amd";
    };

    # Gigabyte BIOS claims the PIIX4 SMBus range (0xB00) via ACPI, so i2c-piix4
    # creates no adapter and RGB Fusion 2 (onboard LEDs + headers) is invisible.
    boot.kernelParams = ["acpi_enforce_resources=lax"];

    hardware.i2c.enable = true;
    users.users.seba9989.extraGroups = ["i2c"];
  };
}

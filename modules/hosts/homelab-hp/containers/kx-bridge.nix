{...}: {
  flake.nixosModules.HomeLabHPContainersKxBridge = {...}: {
    # KX-Bridge: Moonraker-compatible bridge for the Anycubic Kobra X.
    # https://gitea.it-drui.de/viewit/KX-Bridge-Release
    systemd.tmpfiles.rules = [
      "d /var/lib/kx-bridge/config 0750 root root -"
      "d /var/lib/kx-bridge/data 0750 root root -"
      # .env holds printer/MQTT credentials — populate it by hand on the host,
      # it's intentionally not managed declaratively here.
      "f /var/lib/kx-bridge/.env 0600 root root -"
    ];

    networking.firewall.allowedTCPPortRanges = [
      {
        from = 7125;
        to = 7130;
      }
    ];

    virtualisation.quadlet.containers.kx-bridge = {
      containerConfig = {
        image = "gitea.it-drui.de/viewit/kx-bridge:latest";
        volumes = [
          "/var/lib/kx-bridge/config:/app/config"
          "/var/lib/kx-bridge/data:/app/data"
          "/var/lib/kx-bridge/.env:/app/.env:ro"
        ];
        # One port per configured printer (first is 7125); range covers a few extra.
        publishPorts = ["7125-7130:7125-7130"];
        logDriver = "json-file";
        logOptions = ["max-size=10m" "max-file=3"];
      };
      serviceConfig = {
        TimeoutStartSec = "60";
        Restart = "always";
      };
    };
  };
}

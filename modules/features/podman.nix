{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.podman = {
    pkgs,
    lib,
    config,
    ...
  }: {
    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
      };
    };

    environment.systemPackages = with pkgs; [podman podman-compose runc conmon skopeo slirp4netns fuse-overlayfs];

    # Allow non-root containers to access lower port numbers
    boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 80;

    # Enable lingering so containers persist after ssh exit
    systemd.tmpfiles.rules = [
      "f /var/lib/systemd/linger/seba9989"
    ];

    users.users.seba9989 = {
      extraGroups = [
        "podman"
      ];
    };
  };
}

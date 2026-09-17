{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.HomeLabHPConfiguration = {lib, ...}: {
    networking.hostName = "HomeLab-HP";
    imports = [
      self.nixosModules.base
      self.nixosModules.podman
      self.nixosModules.tailscale
      self.nixosModules.HomeLabHPUser
      self.nixosModules.HomeLabHPContainers
      self.nixosModules.HomeLabHPContainersKxBridge
      inputs.quadlet-nix.nixosModules.quadlet
    ];

    # Tailscale SSH: logowanie przez tożsamość w tailnecie/ACL, bez sshd i bez authorized_keys
    services.tailscale.extraUpFlags = ["--ssh"];

    # base dorzuca kdeconnect/firefox/vscode — kdeconnect nie ma sensu na headless serwerze
    programs.kdeconnect.enable = lib.mkForce false;
  };
}

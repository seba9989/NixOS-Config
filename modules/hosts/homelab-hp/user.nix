{...}: {
  flake.nixosModules.HomeLabHPUser = {pkgs, ...}: {
    programs.fish.enable = true;

    users.users.seba9989 = {
      isNormalUser = true;
      description = "Seba9989";
      extraGroups = ["wheel"];
      shell = pkgs.fish;
    };
  };
}

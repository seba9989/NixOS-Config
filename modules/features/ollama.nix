{ inputs, ... }:
{
  flake.nixosModules.ollama =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        (pkgs.ollama.override {
          acceleration = "rocm";
        })
      ];

      services.ollama = {
        enable = true;
        package = pkgs.ollama-rocm;
      };
    };
}

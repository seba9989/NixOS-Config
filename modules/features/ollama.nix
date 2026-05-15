{ ... }:
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
        environmentVariables = {
          HCC_AMDGPU_TARGET = "gfx1031"; # used to be necessary, but doesn't seem to anymore
        };
        # results in environment variable "HSA_OVERRIDE_GFX_VERSION=10.3.0"
        rocmOverrideGfx = "10.3.0";
      };
    };
}

{...}: {
  flake.nixosModules.HomeLabHPContainers = {...}: {
    virtualisation.quadlet.containers.whoami = {
      containerConfig = {
        image = "docker.io/traefik/whoami:latest";
        publishPorts = ["127.0.0.1:8080:80"];
      };
      serviceConfig.TimeoutStartSec = "60";
    };
  };
}

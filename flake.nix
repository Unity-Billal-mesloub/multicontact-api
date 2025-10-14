{
  description = "Trajectory buffer for contact rich robotics applications.";

  inputs = {
    # Use MaximilienNaveau/nix until https://github.com/Gepetto/nix/pull/121 is merged.
    gepetto.url = "github:MaximilienNaveau/nix/topic/mnaveau/add-multicontact-api";
    # gepetto.url = "github:Gepetto/nix/main";
    flake-parts.follows = "gepetto/flake-parts";
    nixpkgs.follows = "gepetto/nixpkgs";
    nix-ros-overlay.follows = "gepetto/nix-ros-overlay";
    systems.follows = "gepetto/systems";
    treefmt-nix.follows = "gepetto/treefmt-nix";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [ inputs.gepetto.flakeModule ];
      perSystem =
        {
          lib,
          pkgs,
          self',
          ...
        }:
        let
          my-src = lib.fileset.toSource {
            root = ./.;
            fileset = lib.fileset.unions [
              ./bindings
              ./include
              ./notebooks
              ./unittest
              ./CMakeLists.txt
              ./package.xml
            ];
          };
        in
        {
          packages = {
            default = self'.packages.py-multicontact-api;
            multicontact-api = pkgs.multicontact-api.overrideAttrs {
              src = my-src;
            };
            py-multicontact-api = pkgs.python3Packages.multicontact-api.overrideAttrs {
              src = my-src;
            };
          };
        };
    };
}

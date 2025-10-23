{
  description = "API to define and store Contact phases and Contact Sequences.";

  inputs = {
    gepetto.url = "github:gepetto/nix";
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
          override = {
            src = lib.fileset.toSource {
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
            patches = [ ];
            postPatch = "";
          };
        in
        {
          packages = {
            default = self'.packages.py-multicontact-api;
            multicontact-api = pkgs.multicontact-api.overrideAttrs override;
            py-multicontact-api = pkgs.python3Packages.multicontact-api.overrideAttrs override;
          };
        };
    };
}

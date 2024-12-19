{
  inputs = rec {
    nixpkgs.url = "github:NixOS/nixpkgs";
    crate2nix.url = "github:nix-community/crate2nix";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, crate2nix, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        generatedCargoNix = crate2nix.tools.${system}.generatedCargoNix {
          name = "min_example";
          src = ./.;
        };
        cargoNix = pkgs.callPackage generatedCargoNix { };

      in
      rec {
        packages = rec {
          default = cargoNix.workspaceMembers.min_example.build;
        };
      });
}

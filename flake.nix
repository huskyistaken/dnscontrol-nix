{
  description = "A nix wrapper for dnscontrol";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      treefmt-nix,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = rec {
          default = dnscontrol-nix;
          dnscontrol-nix = import ./default.nix { inherit pkgs; };
        };
        formatter = (treefmt-nix.lib.evalModule pkgs (import ./treefmt.nix)).config.build.wrapper;
      }
    )
    // {
      lib = import ./lib.nix { inherit (nixpkgs) lib; };
    };
}

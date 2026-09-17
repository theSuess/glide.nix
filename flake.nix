{
  description = "Flake for glide-browser";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      home-manager,
      nixpkgs,
      ...
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          wrapGlide = import ./wrap-glide.nix pkgs.wrapFirefox;
          glide = pkgs.callPackage ./package.nix { };
        in
        rec {
          glide-browser-bin-unwrapped = glide;
          glide-browser-bin = wrapGlide glide-browser-bin-unwrapped {
            pname = "glide-browser";
          };
          default = glide-browser-bin;
        }
      );

      homeModules = {
        default = import ./hm-module {
          inherit self home-manager;
        };
      };

      overlays.default =
        final: prev:
        let
          wrapGlide = import ./wrap-glide.nix final.wrapFirefox;
        in
        {
          glide-browser-bin-unwrapped = final.callPackage ./package.nix { };
          glide-browser-bin = wrapGlide (final.callPackage ./package.nix { }) {
            pname = "glide-browser";
          };
        };
    };
}

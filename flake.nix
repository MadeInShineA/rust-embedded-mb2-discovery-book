{
  description = "Pure Nix shell for rust-embedded Discovery MB2";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      rust-overlay,
    }:

    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ rust-overlay.overlays.default ];
        };

        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          targets = [ "thumbv7em-none-eabihf" ];
          extensions = [
            "rust-src"
            "llvm-tools"
            "rustfmt"
            "clippy"
          ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            rustToolchain

            gdb
            cargo-binutils
            probe-rs-tools
            minicom

            rust-analyzer
          ];
        };
      }
    );
}

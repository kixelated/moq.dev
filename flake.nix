{
  description = "moq.dev - the blog, moq.pub, and moq.watch";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachSystem
      [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ]
      (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              # Everything in the justfile runs through bun: astro, vite, biome,
              # tsc, and wrangler are all `bun run` or `bunx`.
              #
              # This is the version `packageManager` and pr.yml pin to. A bare
              # `bun i` on a newer bun rewrites bun.lock, which is noise in a
              # diff, so the three pins are kept in step. `nix flake update`
              # moving bun is the signal to move the other two.
              bun

              # Astro and Vite target node, and parts of their toolchains shell
              # out to it rather than to bun.
              nodejs_24

              # The task runner every recipe in the justfile is written for.
              just
            ];
          };

          formatter = pkgs.nixfmt-tree;
        }
      );
}

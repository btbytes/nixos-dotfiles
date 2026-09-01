{ config, pkgs, ... }:

{
  # Node.js 26 and related tooling for modern TypeScript development.
  home.packages = with pkgs; [
    nodejs_26
    typescript
    typescript-language-server
    bun
    corepack
    eslint
    prettier
    biome
  ];
}
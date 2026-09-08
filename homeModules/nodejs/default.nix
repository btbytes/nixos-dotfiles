{ config, pkgs, ... }:

let
  # nixpkgs lags upstream (1.3.13); omp needs >= 1.3.14, so pin 1.4.2
  # via overrideAttrs. src follows passthru.sources (finalAttrs), so
  # overriding version + all three platform hashes is sufficient.
  # Refresh hashes with:
  #   nix store prefetch-file --json \
  #     https://github.com/oven-sh/bun/releases/download/bun-v<ver>/<file>
  bun-pinned = pkgs.bun.overrideAttrs (old: {
    version = "1.4.2";
    __intentionallyOverridingVersion = true;
    passthru = old.passthru // {
      sources = {
        "x86_64-linux" = pkgs.fetchurl {
          url = "https://github.com/oven-sh/bun/releases/download/bun-v1.4.2/bun-linux-x64-baseline.zip";
          hash = "sha256-xngEDxT+BEDrg503y9DOTAUaMtpygGrJfeamqra/co8=";
        };
        "aarch64-linux" = pkgs.fetchurl {
          url = "https://github.com/oven-sh/bun/releases/download/bun-v1.4.2/bun-linux-aarch64.zip";
          hash = "sha256-VDKLvC2cjgyfiSxUTWbFeoO4QTnjSQnl7oF1jxrI/ac=";
        };
        "aarch64-darwin" = pkgs.fetchurl {
          url = "https://github.com/oven-sh/bun/releases/download/bun-v1.4.2/bun-darwin-aarch64.zip";
          hash = "sha256-kJh6OhbX21VtiGrD1VHnttPt8KHPQ6yu1iLoZ2vh0S8=";
        };
      };
    };
  });
in
{
  # Node.js 26 and related tooling for modern TypeScript development.
  home.packages = with pkgs; [
    nodejs_26
    typescript
    typescript-language-server
    bun-pinned
    corepack
    eslint
    prettier
    biome
  ];
}

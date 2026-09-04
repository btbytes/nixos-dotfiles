# AGENTS.md — maintainer/agent instructions for this dotfiles repo

Host `aihole`, user `pradeep`. NixOS flake + Home Manager (used as a NixOS
module). Read `README.md` first for the big picture; this file is the
rules-of-engagement checklist.

## Module conventions (follow the existing pattern)

- New concern → new dir `homeModules/<name>/default.nix`, then import it in
  `home.nix` and add a toggle next to the other `*Module.enable` lines.
- Every toggleable module looks like this (see `homeModules/nh/default.nix`,
  the smallest example):
  `options.<name>Module.enable = lib.mkEnableOption ...` + body in
  `config = lib.mkIf config.<name>Module.enable { ... }`.
- Module args come from `extraSpecialArgs` in `flake.nix`: `inputs` (flake
  inputs) and `my` (from `config.nix`). Desktops take `my` for
  terminal/browser/cursor; modules wrapping an external flake (doom, noctalia)
  take `inputs` and add the upstream module via top-level `imports = [...]`.
  Never put `imports` inside `config` — Nix rejects it.
- Desktops (`hyprland` / `niri` / `gnome`) are mutually exclusive: enabling one
  means disabling the others. Shared values (`my.terminal`, `my.browser`,
  `my.fileManager`, cursor) live in `config.nix`, never hardcoded in binds.
- Prefer dedicated `programs.*` / `services.*` modules over bare
  `home.packages` entries when one exists.

## Hard-won gotchas (do not rediscover these)

- **Flakes only see git-tracked files.** After creating files, `git add` them
  or evaluation fails with "not tracked by Git". A dirty tree is fine.
- **Formatter is `nixpkgs-fmt`, NOT `nixfmt`.** `nixd` points at it and the
  whole repo follows it. Verify with `nixpkgs-fmt --check <files>`.
- **Doom (`homeModules/doom`):** never `doom sync`; the store `doomDir`
  rebuilds declaratively. Every module name and `+flag` in `doom.d/init.el`
  must exist in the *locked* Doom source or the build breaks — list them with
  `ls $(nix eval --impure --raw --expr "(builtins.getFlake \"$PWD\").inputs.nix-doom-emacs-unstraightened.inputs.doomemacs-modules.outPath")/modules/<category>/`
  and grep `<module>/README.org` for `- +<flag>` lines. `programs.doom-emacs`
  owns `services.emacs.package`; don't set an Emacs package in `home.nix`.
  `doom doctor` should report 0 errors (`~30 "couldn't find X"` warnings for
  optional per-language tools are expected and harmless).
- **`hardware-configuration.nix`** is generated — don't hand-edit.
  `configuration.nix` is system scope; `home.nix` is user scope; keep them that way.
- Only commit when the user explicitly asks. Staging (`git add`) is fine and
  often required for flake evaluation.

## Verify before handing back

1. `nixpkgs-fmt --check` on touched `.nix` files.
2. Cheap eval first, e.g.
   `nix eval .#nixosConfigurations.aihole.config.home-manager.users.pradeep.<option>`
   — catches option/type errors without building.
3. Build what you changed if feasible (`nix build .#nixosConfigurations.aihole.config.home-manager.users.pradeep.programs.doom-emacs.finalEmacsPackage --no-link`
   for Doom; it native-compiles ~200 packages, so allow up to an hour).
4. The final `sudo nixos-rebuild switch --flake ~/dotfiles#aihole` needs the
   user's password — you can't run it non-interactively; verify everything
   short of it and hand over the command.

## README duty (mandatory)

After **any** modification to this repo, update `README.md` in the same change
so it stays an accurate map of the codebase:

- New/removed/renamed module → update the Layout table and/or Module catalog
  (one row: what it does + why it exists as a module).
- New toggle, changed default desktop, new flake input, new workflow/command →
  update the matching section (toggles, inputs, Workflows).
- Changed Doom modules/flags/tooling → update the Doom Emacs section.
- Changed conventions (naming, formatter, `my` fields) → update both
  `README.md` and this file.
- Keep tables tight: one line per entry, no restating file contents, verify any
  command you document by running it.

# Central, user-specific configuration for the whole setup.
#
# This is the single place to change things like:
#   - username / home directory
#   - the terminal / browser used by desktop keybindings
#   - Obsidian vault location and id
#
# It is passed to NixOS + Home Manager through `extraSpecialArgs` as `my`
# (see flake.nix). Modules access values via `my.foo` so that the same
# homeModules can be shared and customized per machine.

rec {
  # ---- User -----------------------------------------------------------
  username = "pradeep";
  homeDirectory = "/home/${username}";

  # ---- Desktop (used by hyprland / niri keybindings) ------------------
  terminal = "ghostty";
  browser = "google-chrome";
  fileManager = "nautilus";

  # ---- Cursor ---------------------------------------------------------
  cursorName = "Bibata-Modern-Classic";
  cursorSize = 24;

  # ---- Obsidian -------------------------------------------------------
  obsidianVault = "Main Vault";
  obsidianVaultId = "pradeepMainVault";
}

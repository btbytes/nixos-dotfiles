;;; config.el --- Doom private config -*- lexical-binding: t; -*-
;; Managed by Nix (homeModules/doom/doom.d/). Edit here, then rebuild.

(setq user-full-name "Pradeep Gowda"
      user-mail-address "pradeep@btbytes.com")

;; Doom theme + fonts. Fira Code is installed system-wide (see
;; configuration.nix `fonts.packages'); adjust the size to taste.
(setq doom-theme 'doom-one
      doom-font (font-spec :family "Fira Code" :size 13)
      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))

;; Line numbers on for code, off for text.
(setq display-line-numbers-type 'relative)
(add-hook! 'prog-mode-hook #'display-line-numbers-mode)

;; Org lives here.
(setq org-directory "~/org/")

;; Project roots beyond ~/Projects, if any.
;; (setq projectile-project-search-path '("~/Projects/" "~/code/"))

;; Doom's leader menus work without evil (SPC in motion/emacs state via
;; `:config default'). Keep a couple of handy global bindings too.
(map! :leader
      (:prefix ("b" . "buffer")
       :desc "Switch buffer" "b" #'switch-to-buffer)
      (:prefix ("f" . "file")
       :desc "Find file" "f" #'find-file))

;; Accept completion with TAB in corfu when it is active.
(after! corfu
  (define-key corfu-map (kbd "TAB") #'corfu-complete))

;; Per-machine overrides go in ~/.config/doom-local.el (not in the store).
(let ((local (expand-file-name "~/.config/doom-local.el")))
  (when (file-exists-p local)
    (load-file local)))

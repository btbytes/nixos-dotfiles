;;; init.el --- Doom modules -*- lexical-binding: t; -*-
;; Managed by Nix (homeModules/doom/doom.d/). Edit here, then rebuild.
;; NOTE: `:config literate' is intentionally absent: it has no effect under
;; nix-doom-emacs-unstraightened. Keep config in config.el (or set tangleArgs).

(doom! :input
       ;;bidi              ; (tfel ot) thgir ot tfel pleH
       ;;chinese
       ;;japanese
       ;;layout            ; auie,ctsrnm is the superior home row

       :completion
       ;;company           ; the ultimate code completion backend
       (corfu +icons +orderless) ; complete with cap(f), cape and a flying feather
       ;;helm              ; the *other* search engine for love and life
       ;;ido               ; the other *other* search engine...
       ;;ivy               ; a search engine for love and life
       (vertico +icons)    ; the search engine of the future

       :ui
       ;;defer             ; lazy-load `use-package' forms (slows startup)
       doom                ; what makes DOOM look the way it does
       dashboard           ; a nifty splash screen for Emacs
       ;;emoji             ; 🙂
       hl-todo             ; highlight TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
       indent-guides       ; highlighted indent columns
       ligatures           ; ligatures and symbols to make your code pretty again
       ;;minimap           ; show a map of the code on the side
       modeline            ; snazzy, Atom-inspired modeline, plus API
       nav-flash           ; blink cursor line after big motions
       ;;neotree           ; a project drawer, like NERDTree for vim
       ophints             ; highlight the region an operation acts on
       (popup +defaults)   ; tame sudden yet inevitable temporary windows
       smooth-scroll       ; So smooth you won't believe it's not butter
       tabs                ; a tab bar for Emacs
       (treemacs)          ; a project drawer, like neotree but cooler
       unicode             ; extended unicode support for various languages
       (vc-gutter +pretty) ; vcs diff in the fringe
       vi-tilde-fringe     ; fringe tildes to mark beyond EOB
       window-select       ; visually switch windows
       workspaces          ; tab emulation, persistence & separate workspaces
       zen                 ; distraction-free coding or writing

       :editor
       ;;evil              ; come to the dark side, we have cookies (disabled: Doom bindings)
       file-templates      ; auto-snippets for empty files
       fold                ; (nifty) hiding of code blocks
       (format +onsave)    ; automated prettiness
       ;;god               ; run Emacs commands without modifier keys
       ;;lispy             ; vim for lisp, for people who don't like vim
       multiple-cursors    ; editing in many places at once
       ;;objed             ; text object editing for the innocent
       snippets            ; my elves. They type so I don't have to
       word-wrap           ; soft wrapping with language-aware indent

       :emacs
       (dired +icons)      ; making dired pretty [functional]
       electric            ; smarter, keyword-based electric-indent
       undo                ; persistent, smarter undo for your inevitable mistakes
       vc                  ; version-control and Emacs, sitting in a tree

       :term
       eshell              ; the elisp shell that works everywhere
       ;;shell             ; simple shell REPL for Emacs
       ;;term              ; basic terminal emulator for Emacs
       vterm               ; the best terminal emulation in Emacs

       :checkers
       syntax              ; tasing you for every semicolon you forget
       (spell +flyspell)   ; tasing you for misspelling misspelling
       grammar             ; tasing grammar mistake every you make

       :tools
       ;;ansible
       ;;biblio            ; Writes a PhD for you (citation needed)
       direnv
       docker
       editorconfig        ; let someone else argue about tabs vs spaces
       ;;ein               ; tame Jupyter notebooks with emacs
       (eval +overlay)     ; run code, run (also, plasmids)
       lookup              ; navigate your code and its documentation
       (lsp +eglot)        ; M-x vscode
       (magit +forge)      ; a git porcelain for Emacs
       make                ; run make tasks from Emacs
       pass                ; password manager for nerds
       pdf                 ; pdf enhancements
       ;;rgb               ; (module removed upstream)
       ;;taskrunner        ; (module removed upstream)
       ;;terraform         ; infrastructure as code
       tmux                ; an API for interacting with tmux
       tree-sitter         ; syntax and parsing, sitting in a tree...
       ;;upload            ; map local to remote projects via ssh/ftp

       :os
       (:if (featurep :system 'macos) macos) ; improve compatibility with macOS
       tty                 ; improve the terminal Emacs experience

       :lang
       cc                  ; C > C++ == 1
       common-lisp         ; if you've seen one lisp, you've seen them all
       (csharp +lsp)       ; unity, .NET, and mono from the comfort of emacs
       data                ; config/data formats
       emacs-lisp          ; drown in parentheses
       (go +lsp)           ; the hipster dialect
       (haskell +lsp)      ; a language that's lazier than I am
       (java +lsp)         ; the poster child for carpal tunnel syndrome
       (javascript +lsp)   ; all(hope(abandon(ye(who(enter(here))))))
       latex               ; writing papers in Emacs has never been so fun
       (lua +lsp)          ; one-based indices? one-based indices
       markdown            ; writing docs for people to ignore
       nix                 ; I hereby declare "nix geht mehr!"
       ocaml               ; an objective camel
       (org +pretty +roam) ; organize your plain life in plain text
       (python +lsp +pyright) ; beautiful is better than ugly
       (rust +lsp)         ; Fe2O3.unwrap().unwrap().unwrap().unwrap()
       (scala +lsp)        ; java, but good
       sh                  ; she sells {ba,z,fi}sh shells on the C xor
       web                 ; the tubes
       yaml                ; JSON, but readable
       ;;zig               ; C, but simpler

       :email
       ;;(mu4e +org +gmail)
       ;;notmuch
       ;;(wanderlust +gmail)

       :app
       ;;calendar
       ;;emms
       ;;everywhere        ; *leave* Emacs!? You must be joking
       ;;irc               ; how neckbeards socialize
       ;;(rss +org)        ; emacs as an RSS reader

       :config
       ;;literate          ; (disabled under Nix: use tangleArgs instead)
       (default +bindings +smartparens))

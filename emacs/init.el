;; -*- mode: emacs-lisp; lexical-binding: t -*-
;;
;; NOTE: `init.el' is auto-generated from `emacs.org'. Save changes to `emacs.org' to edit this file.

(add-hook 'emacs-startup-hook
	  (lambda ()
	    (message "Emacs loaded in %s."
		     (emacs-init-time))))

(scroll-bar-mode -1)                     ; disable visible scrollbar
(tool-bar-mode -1)                       ; disable the toolbar
(tooltip-mode -1)                        ; disable tooltips
(set-fringe-mode 10)                     ; give some breathing room
(menu-bar-mode -1)                       ; disable the menu bar
(setq frame-resize-pixelwise 1)          ; maximize frame without gaps
(setq visible-bell 1)                    ; set up visible bell
(pixel-scroll-precision-mode 1)          ; enable smooth scrolling
(add-hook
 'after-init-hook
 #'recentf-mode 1)                       ; make emacs track opened files
(global-auto-revert-mode 1)              ; auto-revert buffers on file change
(customize-set-variable
 'global-auto-revert-non-file-buffers t) ; auto-revert dired and other buffers
(delete-selection-mode)                  ; delete highlighted section when typed over
(setq use-short-answers t)               ; answer y/n instead of yes/no
(global-visual-line-mode t)              ; enable visual-line-based editing
(set-default 'truncate-lines t)          ; truncate lines by default
(setq native-comp-async-report-warnings-errors 'silent) ; suppress native-comp warnings 

; handle files with long lines better
(setq-default bidi-paragraph-direction 'left-to-right)
(setq-default bidi-inhibit-bpa t)
(global-so-long-mode 1)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package no-littering)

(require 'package)

(setq package-archives '(
       ("melpa" . "https://melpa.org/packages/")
       ("melpa stable" . "https://stable.melpa.org/packages/")
       ("org" . "https://orgmode.org/elpa/")
       ("elpa" . "https://elpa.gnu.org/packages/")
       ))

(package-initialize)

(eval-when-compile
  (require 'use-package))

(setq use-package-always-ensure t)

(use-package diminish)

(defvar rfh/default-font-size 160)
(defvar rfh/default-variable-font-size 160)

(defun rfh/set-font-faces ()
  (message "Setting faces!")
  (set-face-attribute 'default nil :font "JetBrains Mono" :weight 'light :height rfh/default-font-size)

  ;; Set the fixed pitch face
  (set-face-attribute 'fixed-pitch nil :font "JetBrains Mono" :weight 'light :height rfh/default-font-size)

  ;; Set the variable pitch face
  (set-face-attribute 'variable-pitch nil :font "Fira Sans Condensed" :weight 'light :height rfh/default-variable-font-size :weight 'light))

(rfh/set-font-faces)

(use-package modus-themes
  :ensure t
  :demand t
  :config
  ;; Add all your customizations prior to loading the themes
  (setq modus-themes-italic-constructs t
	modus-themes-bold-constructs nil
	modus-themes-org-blocks 'tinted-background)

  ;; Maybe define some palette overrides, such as by using our presets
  (setq modus-themes-common-palette-overrides
	modus-themes-preset-overrides-faint)

  ;; Load the theme of your choice.
  (load-theme 'modus-vivendi-tinted :no-confirm)
  (setq modus-themes-to-toggle '(modus-vivendi-tinted modus-operandi-tinted))
  :bind ("<f5>" . modus-themes-toggle))

(use-package all-the-icons
  :if (display-graphic-p)
  :commands all-the-icons-install-fonts
  :init
  (unless (find-font (font-spec :name "all-the-icons"))
    (all-the-icons-install-fonts t)))

(use-package all-the-icons-dired
  :if (display-graphic-p)
  :hook (dired-mode . all-the-icons-dired-mode))


(use-package all-the-icons-completion
  :init
  (all-the-icons-completion-mode)
  :hook
  (marginalia-mode-hook . all-the-icons-completion-marginalia-setup))

(use-package helpful
  :config
  (define-key helpful-mode-map [remap revert-buffer] #'helpful-update)
  (global-set-key [remap describe-command] #'helpful-command)
  (global-set-key [remap describe-function] #'helpful-callable)
  (global-set-key [remap describe-key] #'helpful-key)
  (global-set-key [remap describe-symbol] #'helpful-symbol)
  (global-set-key [remap describe-variable] #'helpful-variable)
  (global-set-key (kbd "C-h F") #'helpful-function)

  ;; Bind extra `describe-*' commands
  (global-set-key (kbd "C-h K") #'describe-keymap))

(use-package elisp-demos
  :config
  (advice-add 'helpful-update :after #'elisp-demos-advice-helpful-update))

(defun rfh/display-line-numbers-hook ()
  (display-line-numbers-mode t)
  )
(add-hook 'prog-mode-hook 'rfh/display-line-numbers-hook)

(use-package savehist
    :init
    (savehist-mode))

(use-package vertico
  :init
  (vertico-mode)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  (setq vertico-cycle t)

  :config
  (with-eval-after-load 'evil
    (define-key vertico-map (kbd "C-j") 'vertico-next)
    (define-key vertico-map (kbd "C-k") 'vertico-previous)
    (define-key vertico-map (kbd "M-h") 'vertico-directory-up)))


(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
		  (replace-regexp-in-string
		   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
		   crm-separator)
		  (car args))
	  (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
	'(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :after vertico
  :init
  (marginalia-mode)
  :config
  (customize-set-variable 'marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil)))

(use-package consult
  :config
  (global-set-key (kbd "C-s") 'consult-line)
  (define-key minibuffer-local-map (kbd "C-r") 'consult-history)
  (setq completion-in-region-function #'consult-completion-in-region))

(use-package embark
    :bind
    (("C-:" . embark-act)       ;; pick some comfortable binding
     ("C-;" . embark-dwim)        ;; good alternative: M-.
     ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'
    :init
    ;; Optionally replace the key help with a completing-read interface
    (setq prefix-help-command #'embark-prefix-help-command)

    :config
    ;; Hide the mode line of the Embark live/completions buffers
    (add-to-list 'display-buffer-alist
		 '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
		   nil
		   (window-parameters (mode-line-format . none))))
    (global-set-key [remap describe-bindings] #'embark-bindings)
    (global-set-key (kbd "C-.") #'embark-act)
    (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package corfu
  :custom
  (corfu-auto t)          ;; Enable auto completion
  (corfu-separator ?_) ;; Set to orderless separator, if not using space
  (corfu-quit-no-match 'separator)
  :bind
  ;; Another key binding can be used, such as S-SPC.
  (:map corfu-map ("S-SPC" . corfu-insert-separator))
  :init
  (global-corfu-mode))

(require 'corfu-popupinfo)
(corfu-popupinfo-mode t)

(define-key corfu-map (kbd "M-p") #'corfu-popupinfo-scroll-down)
(define-key corfu-map (kbd "M-n") #'corfu-popupinfo-scroll-up)
(define-key corfu-map (kbd "M-d") #'corfu-popupinfo-toggle)

(use-package cape
  :config
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)

  ;; Silence the pcomplete capf, no errors or messages!
  ;; Important for corfu
  (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-silent)

  ;; Ensure that pcomplete does not write to the buffer
  ;; and behaves as a pure `completion-at-point-function'.
  (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-purify)
  (add-hook 'eshell-mode-hook
            (lambda () (setq-local corfu-quit-at-boundary t
                                   corfu-quit-no-match t
                                   corfu-auto nil)
              (corfu-mode)))
  )

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll nil)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-undo-system 'undo-redo))

(use-package evil-collection
  :diminish evil-collection-unimpaired-mode
  :after evil
  :config
  (evil-collection-init))

(use-package evil-nerd-commenter)

(use-package general
  :config
  (general-evil-setup t)
  (general-create-definer rfh/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-M-SPC"))

(rfh/leader-keys
  "SPC"   '(execute-extended-command :which-key "M-x")
  "TAB"   '(evil-window-next :which-key "cycle windows")
  "f"     '(:ignore t :which-key "files")
  "ff"    '(find-file :which-key "find file")
  "fr"    '(consult-recent-file :which-key "recent files")
  "fs"    '(save-buffer :which-key "save current buffer")
  "fh"    '(consult-org-heading :which-key "go to org heading")
  "w"     '(:ignore t :which-key "windows")
  "wq"    '(quit-window :which-key "quit window")
  "wd"    '(delete-window :which-key "delete window")
  "wD"    '(delete-other-windows :which-key "delete other windows")
  "b"     '(:ignore t :which-key "buffers")
  "bb"    '(consult-buffer :which-key "switch buffer")
  "bd"    '(kill-current-buffer :which-key "kill current buffer")
  "bD"    '(kill-buffer :which-key "kill buffer")
  "t"     '(:ignore t :which-key "toggle")
  "tv"    '(visual-line-mode :which-key "visual line mode")
  "tt"    '(modus-themes-toggle :which-key "light/dark mode")
  "tT"    '(consult-theme :which-key "switch color theme")
  ";"     '(evilnc-comment-or-uncomment-lines :which-key "comment/uncomment lines")
 )

(use-package hydra
  :defer t)

(rfh/leader-keys
  "F"  '(:ignore t :which-key "frames")
  "Fd" '(delete-frame :which-key "delete current frame")
  "FD" '(delete-other-frames :which-key "delete other frames")
  "Fm" '(toggle-frame-maximized :which-key "toggle frame maximization")
)

(use-package ace-window
  :bind
  ("M-o" . 'ace-window))

(setq aw-dispatch-always t)

(use-package magit
  :commands magit-status
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(rfh/leader-keys
  "g"   '(:ignore t :which-key "git")
  "gs"  'magit-status
  "gd"  'magit-diff-unstaged
  "gc"  'magit-branch-or-checkout
  "gl"   '(:ignore t :which-key "log")
  "glc" 'magit-log-current
  "glf" 'magit-log-buffer-file
  "gb"  'magit-branch
  "gP"  'magit-push-current
  "gp"  'magit-pull-branch
  "gf"  'magit-fetch
  "gF"  'magit-fetch-all
  "gr"  'magit-rebase)

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer)
  (define-key dired-mode-map [kbd "SPC"] nil)
  )

(use-package dired-single
  :after dired)

(use-package diredfl
  :after dired
  :config
  (add-hook 'dired-mode-hook 'diredfl-global-mode))

(use-package dired-open
  :after dired
  :config
  ;; Doesn't work as expected!
  ;; (add-to-list 'dired-open-functions #'dired-open-xdg t)
  (setq dired-open-extensions '(
				;; ("png" . "feh")
				("mkv" . "vlc")))
  )

(use-package dired-hide-dotfiles
  ;; :hook (dired-mode . dired-hide-dotfiles-mode)
  :after dired
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "H" 'dired-hide-dotfiles-mode))

(rfh/leader-keys
"d" '(dired :which-key "dired"))

(defhydra hydra-dired (:hint nil :color pink)
  "
_+_ mkdir          _v_iew           _m_ark             _(_ details        _i_nsert-subdir    wdired
_C_opy             _O_ view other   _U_nmark all       _)_ omit-mode      _$_ hide-subdir    C-x C-q : edit
_D_elete           _o_pen other     _u_nmark           _l_ redisplay      _w_ kill-subdir    C-c C-c : commit
_R_ename           _M_ chmod        _t_oggle           _g_ revert buf     _e_ ediff          C-c ESC : abort
_Y_ rel symlink    _G_ chgrp        _E_xtension mark   _s_ort             _=_ pdiff
_S_ymlink          ^ ^              _F_ind marked      _TAB_ toggle hydra   \\ flyspell
_r_sync            ^ ^              ^ ^                ^ ^                _?_ summary
_z_ compress-file  _A_ find regexp
_Z_ compress       _Q_ repl regexp

T - tag prefix
"
  ("\\" dired-do-ispell)
  ("(" dired-hide-details-mode)
  (")" dired-omit-mode)
  ("+" dired-create-directory)
  ("=" diredp-ediff)         ;; smart diff
  ("?" dired-summary)
  ("$" diredp-hide-subdir-nomove)
  ("A" dired-do-find-regexp)
  ("C" dired-do-copy)        ;; Copy all marked files
  ("D" dired-do-delete)
  ("E" dired-mark-extension)
  ("e" dired-ediff-files)
  ("F" dired-do-find-marked-files)
  ("G" dired-do-chgrp)
  ("g" revert-buffer)        ;; read all directories again (refresh)
  ("i" dired-maybe-insert-subdir)
  ("l" dired-do-redisplay)   ;; relist the marked or singel directory
  ("M" dired-do-chmod)
  ("m" dired-mark)
  ("O" dired-display-file)
  ("o" dired-find-file-other-window)
  ("Q" dired-do-find-regexp-and-replace)
  ("R" dired-do-rename)
  ("r" dired-do-rsynch)
  ("S" dired-do-symlink)
  ("s" dired-sort-toggle-or-edit)
  ("t" dired-toggle-marks)
  ("U" dired-unmark-all-marks)
  ("u" dired-unmark)
  ("v" dired-view-file)      ;; q to exit, s to search, = gets line #
  ("w" dired-kill-subdir)
  ("Y" dired-do-relsymlink)
  ("z" diredp-compress-this-file)
  ("Z" dired-do-compress)
  ("q" nil)
  ("TAB" nil :color blue))

(define-key dired-mode-map (kbd "<tab>") 'hydra-dired/body)

;; (use-package openwith
;;   :config
;;   (setq openwith-associations
;;     (list
;;       (list (openwith-make-extension-regexp
;;              '("mpg" "mpeg" "mp3" "mp4"
;;                "avi" "wmv" "wav" "mov" "flv"
;;                "ogm" "ogg" "mkv"))
;;              "mpv"
;;              '(file))
;;       (list (openwith-make-extension-regexp
;;              '("xbm" "pbm" "pgm" "ppm" "pnm"
;;                "png" "gif" "bmp" "tif" "jpeg")) ;; Removed jpg because Telega was
;;                                                 ;; causing feh to be opened...
;;              "feh"
;;              '(file))
;;       (list (openwith-make-extension-regexp
;;              '("pdf"))
;;              "zathura"
;;              '(file))))
;;   (openwith-mode 1))

(defun sudo-find-file (file)
    "Opens FILE with root privileges."
    (interactive "FFind file: ")
    (set-buffer
     (find-file (concat "/sudo::" (expand-file-name file)))))

(rfh/leader-keys
"fF" '(sudo-find-file :which-key "sudo find file"))

(defun sudo-remote-find-file (file)
    "Opens repote FILE with root privileges."
    (interactive "FFind file: ")
    (setq begin (replace-regexp-in-string  "scp" "ssh" (car (split-string file ":/"))))
    (setq end (car (cdr (split-string file "@"))))
    (set-buffer
     (find-file (format "%s" (concat begin "|sudo:root@" end)))))

(when (executable-find "ispell")
  (add-hook 'text-mode-hook #'flyspell-mode)
  (add-hook 'prog-mode-hook #'flyspell-prog-mode))

(electric-pair-mode 1) ; auto-insert matching bracket
(show-paren-mode 1)    ; turn on paren match highlighting

(use-package org
  :hook
  (org-mode-hook . visual-line-mode)
  :config
  (setq org-ellipsis " ▾"
	org-hide-emphasis-markers t
	org-src-fontify-natively t
	org-src-tab-acts-natively t
	org-edit-src-content-indentation 2
	org-src-preserve-indentation nil
	org-startup-folded 'content
	org-cycle-separator-lines 2))


(with-eval-after-load 'org

  (rfh/leader-keys
    "o"   '(:ignore t :which-key "org-mode")
    "oe" '(org-export-dispatch :which-key "export")
    "os" '(org-edit-src-code :which-key "edit src block")
    )

  ;; Make invisible parts of Org elements appear visible.
  (use-package org-appear
    :hook
    (org-mode-hook . org-appear-mode))

  ;; Return or mouse-1 click follows link
  (customize-set-variable 'org-return-follows-link 1)
  (customize-set-variable 'org-mouse-1-follows-link 1)

  ;; Display links as the description provided
  (customize-set-variable 'org-link-descriptive 1)

  ;; Hide markup markers
  (customize-set-variable 'org-hide-emphasis-markers 1)

  ;; disable auto-pairing of "<" in org-mode
  (add-hook 'org-mode-hook (lambda ()
			     (setq-local electric-pair-inhibit-predicate
					 `(lambda (c)
					    (if (char-equal c ?<) t (,electric-pair-inhibit-predicate c))))))
  )

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun rfh/org-mode-visual-fill ()
  (setq visual-fill-column-width 80
	visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
 :hook (org-mode . rfh/org-mode-visual-fill))

(require 'org-tempo)
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))

(setq org-export-with-smart-quotes t)

(use-package org-rich-yank)

(message "reached end of init file")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(no-littering org-rich-yank visual-fill-column org-bullets org-appear dired-hide-dotfiles dired-open diredfl dired-single magit ace-window hydra general evil-nerd-commenter evil-collection evil which-key cape corfu embark-consult embark consult marginalia orderless vertico elisp-demos helpful all-the-icons-completion all-the-icons-dired all-the-icons modus-themes diminish)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

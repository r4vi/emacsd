(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

;; Add in your own as you wish:
(defvar my-packages 
 '(4clojure
   ace-jump-mode
   cider-decompile
   cider-tracing
   clj-refactor
   clojure-project-mode
   dirtree
   clojure-test-mode
   cider
   clojurescript-mode
   coffee-mode
   evil-leader
   evil-paredit
   evil-tabs
   elscreen
   evil
   flymake
   flymake-coffee
   flymake-python-pyflakes
   flymake-sass
   flymake-easy
   git-rebase-mode
   helm-descbinds
   helm-ls-git
   helm-projectile
   helm
   highlight
   jade-mode
   javap-mode
   key-chord
   kibit-mode
   markdown-mode
   multiple-cursors
   fringe-helper clojure-mode popup project-mode levenshtein projectile pkg-info epl protobuf-mode python-mode rainbow-delimiters request s sass-mode haml-mode smart-mode-line smartparens dash smooth-scrolling starter-kit-bindings starter-kit-lisp elisp-slime-nav cl-lib starter-kit magit ido-ubiquitous smex find-file-in-project idle-highlight-mode paredit surround sws-mode undo-tree yasnippet zenburn-theme)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p))) 

(add-hook 'after-init-hook 'global-company-mode)

(add-hook 'cider-repl-mode-hook
            'cider-turn-on-eldoc-mode)

(add-hook 'cider-repl-mode-hook 'paredit-mode)
(eval-after-load 'paredit '(define-key paredit-mode-map (kbd "C-M-]") 'paredit-forward-barf-sexp))
(eval-after-load 'paredit '(define-key paredit-mode-map (kbd "C-M-[") 'paredit-backward-barf-sexp))
(eval-after-load 'paredit '(define-key paredit-mode-map (kbd "M-]") 'paredit-forward-slurp-sexp))
(eval-after-load 'paredit '(define-key paredit-mode-map (kbd "M-[") 'paredit-backward-slurp-sexp))

(eval-after-load 'company '(add-to-list 'company-backends 'company-cider))

(setq org-directory "~/Dropbox/org/")
(setq org-mobile-directory "~/Dropbox/org/m/")
(setq org-mobile-inbox-for-pull "~/Dropbox/org/log.org")
(setq org-agenda-files '("~/Dropbox/org/log.org"))

(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(remove-hook 'prog-mode-hook 'esk-turn-on-hl-line-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Early requirements.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Customizations (from M-x customze-*)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(coffee-tab-width 2)
 '(company-backends (quote (company-elisp company-bbdb company-nxml company-css company-eclim company-semantic company-clang company-xcode company-ropemacs company-cmake company-capf (company-dabbrev-code company-gtags company-etags company-keywords) company-oddmuse company-files company-dabbrev)))
 '(max-lisp-eval-depth 6000)
 '(max-specpdl-size 3000)
 ;;'(nrepl-hide-special-buffers t)
 ;;'(nrepl-popup-stacktraces-in-repl t)
 '(recentf-max-saved-items 50))
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Basic Vim Emulation.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(evil-mode t)
(global-evil-tabs-mode 1)
(setq evil-default-cursor t)

(evil-ex-define-cmd "Exp[lore]" 'dired-jump)
(evil-ex-define-cmd "color[scheme]" 'customize-themes)
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Nice-to-haves...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-surround-mode t)

(helm-mode t)
(helm-descbinds-mode t)
(recentf-mode t)

(if after-init-time
    (sml/setup)
  (add-hook 'after-init-hook 'sml/setup))

(evil-define-key 'normal global-map
  "\C-p" 'helm-mini
  "q:" 'helm-complex-command-history
  "\\\\w" 'evil-ace-jump-word-mode)

;;; Uncomment these key-chord lines if you like that "remap 'jk' to ESC" trick.
(key-chord-mode t)
(key-chord-define evil-insert-state-map "jk" 'evil-normal-state)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Filetype-style hooks.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun standard-lisp-modes ()
  (rainbow-delimiters-mode t)
  (require 'evil-paredit)
  (paredit-mode t)
  (evil-paredit-mode t)
  (local-set-key (kbd "RET") 'newline-and-indent))

;;; Emacs Lisp
(add-hook 'emacs-lisp-mode-hook
          '(lambda ()
             (standard-lisp-modes)))

(evil-define-key 'normal emacs-lisp-mode-map
  "\M-q" 'paredit-reindent-defun
  "\C-c\C-c" 'eval-defun
  "K" '(lambda ()
         (interactive)
         (describe-function (symbol-at-point))))

;;; Clojure

(setq cider-hide-special-buffers t)

(add-hook 'clojure-mode-hook
          '(lambda ()
             (standard-lisp-modes)
             (mapc '(lambda (char)
                      (modify-syntax-entry char "w" clojure-mode-syntax-table))
                   '(?- ?_ ?/ ?< ?> ?: ?' ?.))
  
             ;(require 'clojure-test-mode)
  
             ;(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
             (add-hook 'cider-repl-mode-hook 'paredit-mode)
             (add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode)
             ))

(evil-define-key 'normal clojure-mode-map
  "\M-q" 'paredit-reindent-defun
  ;;"gK" 'nrepl-src
  ;;"K"  'ac-nrepl-popup-doc
  )

(require 'smooth-scrolling)
(setq smooth-scroll-margin 5)

(defvar blink-cursor-colors (list  "#92c48f" "#6785c5" "#be369c" "#d9ca65")
  "On each blink the cursor will cycle to the next color in this list.")

(setq blink-cursor-count 300)
(defun blink-cursor-timer-function ()
  "Zarza wrote this cyberpunk variant of timer `blink-cursor-timer'. 
Warning: overwrites original version in `frame.el'.

This one changes the cursor color on each blink. Define colors in `blink-cursor-colors'."
  (when (not (internal-show-cursor-p))
    (when (>= blink-cursor-count (length blink-cursor-colors))
      (setq blink-cursor-count 0))
    (set-cursor-color (nth blink-cursor-count blink-cursor-colors))
    (setq blink-cursor-count (+ 1 blink-cursor-count))
    )
  (internal-show-cursor nil (not (internal-show-cursor-p)))) 

(global-evil-leader-mode)

(require 'evil-leader)
;(require 'cider-interaction)
(evil-leader/set-key-for-mode 'clojure-mode "x" 'cider-eval-expression-at-point)
(evil-leader/set-key "b" 'helm-buffers-list)
(evil-leader/set-key "p" 'helm-projectile)
(evil-leader/set-key "q" 'cider-popup-buffer-quit)
(evil-leader/set-key "c" 'comment-or-uncomment-region)
(require 'evil-states)
(require 'evil-ex)
(require 'evil-commands)

(define-key evil-motion-state-map (kbd "C-^") 'buffer-menu)
(evil-ex-define-cmd "b[uffer]" 'buffer-menu)


(when (display-graphic-p)
  (set-face-attribute 'default nil :font "Source Code Pro-11"))

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(setq create-lockfiles nil)


(add-to-list 'auto-mode-alist '("\.cljs$" . clojure-mode))

(load-theme 'wombat t)




(require 'clj-refactor)
(add-hook 'clojure-mode-hook (lambda ()
                (clj-refactor-mode 1)
                (cljr-add-keybindings-with-prefix "C-c C-m")))


(yas/global-mode 1)
(blink-cursor-mode 1)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(rainbow-delimiters-depth-1-face ((t (:foreground "yellow"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "lawn green"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "orange"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "salmon"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "sky blue"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "magenta1"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "LightPink1"))))
 '(rainbow-delimiters-depth-9-face ((t (:foreground "goldenrod")))))


(load-file "~/.emacs.d/lib/eval-sexp-fu.el")
(load-file "~/.emacs.d/lib/highlight-flash-conf.el")
(autoload 'dirtree "dirtree" "Add directory to tree view" t)
(add-to-list 'auto-mode-alist '("\\.sls\\'" . yaml-mode))
(server-start)

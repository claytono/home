(add-to-list 'load-path "~/.emacs")
(add-to-list 'load-path "~/.emacs/tramp")
(add-to-list 'load-path "~/.emacs/nxml-mode")
(add-to-list 'load-path "~/.emacs/tuareg-mode")
(add-to-list 'load-path "~/.emacs/ruby")
(add-to-list 'load-path "~/.emacs/muse/lisp")

; Open all files in unix mode, not dos.
(add-hook 'find-file-hook 'find-file-check-line-endings)

(defun dos-file-endings-p ()
  (string-match "dos" (symbol-name buffer-file-coding-system)))

(defun find-file-check-line-endings ()
  (when (dos-file-endings-p)
    (set-buffer-file-coding-system 'undecided-unix)
    (set-buffer-modified-p nil)))

; Turn on font lock mode
(global-font-lock-mode t)
(if (fboundp 'global-font-lock-mode)
    (setq font-lock-auto-fontify t))
(defconst font-lock-maximum-decoration t)

(unless (eq window-system 'mac)
    (set-default-font "-*-Lucida Console-normal-r-*-*-*-100-*-*-c-*-*-iso8859-1"))

(when (eq window-system 'mac) 
  (setenv "PATH" (concat "/usr/local/bin" path-separator
			 "/opt/local/bin" path-separator
                         (getenv "PATH") )
	  )
  (set-frame-position (selected-frame) 5 0)
  (set-frame-height (selected-frame) 65)
  (set-frame-width (selected-frame) 90)
  (setq mac-allow-anti-aliasing nil)
  )

(global-set-key "\M-g" 'goto-line)
(global-set-key "\M-j" 'join-line)

(setq inhibit-startup-message t)
(tool-bar-mode -1)
(line-number-mode t)
(column-number-mode t)
(display-time)
(transient-mark-mode t)
(show-paren-mode t)
(setq-default indent-tabs-mode nil)
(setq compilation-scroll-output t)

; this makes / or ~ erase everything in the file selection mini-buffer
(require 'minibuf-electric-gnuemacs)

(require 'yaml-mode)
(load-file "~/.emacs/nxml-mode/rng-auto.el")
(add-to-list 'auto-mode-alist '("\\.\\(docbook\\|xml\\|xsl\\|rng\\|xhtml\\)\\'"
                         . nxml-mode))
(add-to-list 'auto-mode-alist '("\\(\\.yml\\|\\.yaml\\)" . yaml-mode))

;(require 'muse-mode)     ; load authoring mode
;(require 'muse-html)     ; load publishing styles I use
;(require 'muse-latex)
;(require 'muse-texinfo)
;(require 'muse-docbook)
;(require 'muse-project)  ; publish files in projects

(require 'tramp)
(if (eq window-system 'w32)
    (setq tramp-default-method "plink")
  (setq tramp-default-method "ssh"))
(setq tramp-default-user "coneill")

(unless (eq window-system nil)
    (progn (require 'color-theme)
           (load "xterm-256color")    
           (color-theme-arjen)))

; This is a list of stuff that needs gets 
(defun my-prog-mode-hook ()
  "Initialize programming modes"
  (interactive)
  (progn (imenu-add-menubar-index)
	 (comment-wrap-mode)
	 ))

; wrap text inside of comments
(defun comment-wrap-mode ()
  (auto-fill-mode 1)
  (set (make-local-variable 'fill-nobreak-predicate)
       (lambda ()
	 (not (eq (get-text-property (point) 'face)
		  'font-lock-comment-face)
	      ))))

; cperl
(defalias 'perl-mode 'cperl-mode)
(setq cperl-invalid-face nil)
(setq cperl-font-lock t)
(setq cperl-info-on-command-no-prompt t)
(setq cperl-electric-keywords t)
(setq cperl-continued-statement-offset 0)
(add-to-list 'auto-mode-alist '("\\.t$" . cperl-mode))

(require 'cmake-mode)
(setq auto-mode-alist
      (append '(("CMakeLists\\.txt\\'" . cmake-mode)
                ("\\.cmake\\'" . cmake-mode))
              auto-mode-alist))

;; Disable color output from Test::Class (and anything else that uses
;; Term::ANSIColor
(setenv "ANSI_COLORS_DISABLED" "1")

;; ** PerlySense **
;; The PerlySense prefix key (unset only if needed)
(global-unset-key "\C-o")
(setq perly-sense-key-prefix "\C-o")
(setq perly-sense-load-flymake nil)

(setq perly-sense-external-dir (shell-command-to-string "perly_sense external_dir"))
(if (string-match "Devel.PerlySense.external" perly-sense-external-dir)
    (progn
      (message
       "PerlySense elisp files  at (%s) according to perly_sense, loading..."
       perly-sense-external-dir)
      (setq load-path (cons
                       (expand-file-name
                        (format "%s/%s" perly-sense-external-dir "emacs")
                        ) load-path))
      (load "perly-sense")
          (if perly-sense-load-flymake (load "perly-sense-flymake"))
          )
  (message "Could not identify PerlySense install dir.
    Is Devel::PerlySense installed properly?
    Does 'perly_sense external_dir' give you a proper directory? (%s)" perly-sense-external-dir)
  )


; ocaml
(add-hook 'tuareg-mode-hook
          '(lambda () 
             (setq tuareg-in-indent 0)
))

; Disable annoying questions caused by SftpDrive's timestamp handling
(when (eq system-type 'windows-nt)
  (defun ask-user-about-supersession-threat (filename)
    (message "ask-user-about-supersession-threat disabled"))
  (defun verify-visited-file-modtime (xxxx)
    (message "verify-visited-file-modtime disabled"))
  )


(setq ispell-program-name "aspell")
(setq ispell-extra-args '("--sug-mode=ultra"))

(add-hook 'c-mode-hook        'my-prog-mode-hook)
(add-hook 'c++-mode-hook      'my-prog-mode-hook)
(add-hook 'cperl-mode-hook    'my-prog-mode-hook)
(add-hook 'cperl-mode-hook    'my-prog-mode-hook)
(add-hook 'makefile-mode-hook 'my-prog-mode-hook)
(add-hook 'python-mode-hook   'my-prog-mode-hook)
(add-hook 'sh-mode-hook       'my-prog-mode-hook)

(require 'session)
(add-hook 'after-init-hook 'session-initialize)

(setq auto-mode-alist (cons '("\\.ml\\w?" . tuareg-mode) auto-mode-alist))
(autoload 'tuareg-mode "tuareg" "Major mode for editing Caml code" t)
(autoload 'camldebug "camldebug" "Run the Caml debugger" t)

; css mode
(autoload 'css-mode "css-mode" "Mode for editing CSS files" t)
(setq auto-mode-alist (append '(("\\.css$" . css-mode))
                              auto-mode-alist))

; puppet-mode
(autoload 'puppet-mode "puppet-mode"
  "Mode for editing puppet source files" t)
(setq auto-mode-alist
      (append '(("\\.pp$" . puppet-mode)) auto-mode-alist))

; graphviz-mode
(autoload 'graphviz-dot-mode "graphviz-dot-mode"
  "Mode for editing graphviz source files" t)
(setq auto-mode-alist
      (append '(("\\.dot$" . graphviz-dot-mode)) auto-mode-alist))
(setq graphviz-dot-auto-indent-on-newline nil)
(setq graphviz-dot-auto-indent-on-braces nil)
(setq graphviz-dot-auto-indent-on-semi nil)

; lua-mode
(autoload 'lua-mode "lua-mode"
  "Mode for editing lua source files" t)
(setq auto-mode-alist
      (append '(("\\.lua$" . lua-mode)) auto-mode-alist))

; ruby-mode
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)
(setq auto-mode-alist
      (append '(("\\.rb$" . ruby-mode)
                ("Rakefile$" . ruby-mode)) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode))
                                     interpreter-mode-alist))
(autoload 'run-ruby "inf-ruby"
  "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook
          '(lambda ()
            (inf-ruby-keys)))

(autoload 'snmp-mode "snmp-mode"
  "Mode for editing SNMP mibs" t)
(setq auto-mode-alist
      (append '(("\\.my"  . snmp-mode)
                ("\\.mib" . snmp-mode))
              auto-mode-alist))

; Reload all buffers from disk
(defun revert-all-buffers()
  "Refreshs all open buffers from their respective files"
  (interactive)
  (let* ((list (buffer-list))
         (buffer (car list)))
    (while buffer
      (if (string-match "\\*" (buffer-name buffer)) 
          (progn
            (setq list (cdr list))
            (setq buffer (car list)))
        (progn
          (set-buffer buffer)
          (revert-buffer t t t)
          (setq list (cdr list))
          (setq buffer (car list))))))
  (message "Refreshing open files"))

(setq custom-file "~/.emacs/customizations.el");
(load custom-file)


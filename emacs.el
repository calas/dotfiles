;;
;; .emacs --- My personal Emacs startup script
;;
;; Made By Jorge Calás Lozano.
;; Email   <calas@qvitta.net>
;;

;;;;;;;;;;;;;;;;;;
;; EMACS SERVER ;;
;;;;;;;;;;;;;;;;;;

;; Only start emacs-server it is not already started
(when (or (not (boundp 'server-process))
	  (not (eq (process-status server-process) 'listen)))
  (server-start))

;; Set my data
(setq user-full-name "Jorge Calás Lozano")
(setq user-mail-address "calas@qvitta.net")

;; Share clipboard with other X applications
(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

;; Set coding system to UTF-8
(prefer-coding-system 'utf-8)

;; Type y/n instead of yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;; C-v & M-v return to original position
(setq scroll-preserve-screen-position 1)

;; Enable disabled features
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'capitalize-region 'disabled nil)

;; Frame title bar formatting to show full path of file
(setq-default
 frame-title-format
 (list '((buffer-file-name " %f" (dired-directory
                                  dired-directory
                                  (revert-buffer-function " %b"
                                  ("%b - Dir:  " default-directory)))))))
(setq-default
 icon-title-format
 (list '((buffer-file-name " %f" (dired-directory
                                  dired-directory
                                  (revert-buffer-function " %b"
                                  ("%b - Dir:  " default-directory)))))))

;; Put autosave files (ie #foo#) in one place, *not*
;; scattered all over the file system!
(defvar autosave-dir
  (concat "/tmp/emacs_autosaves/" (user-login-name) "/"))
(make-directory autosave-dir t)
(setq auto-save-file-name-transforms `(("\\(?:[^/]*/\\)*\\(.*\\)" ,(concat autosave-dir "\\1") t)))

(defun make-auto-save-file-name ()
  (concat autosave-dir
   (if buffer-file-name
      (concat "#" (file-name-nondirectory buffer-file-name) "#")
    (expand-file-name
     (concat "#%" (buffer-name) "#")))))

;; Put backup files (ie foo~) in one place too. (The backup-directory-alist
;; list contains regexp=>directory mappings; filenames matching a regexp are
;; backed up in the corresponding directory. Emacs will mkdir it if necessary.)
(defvar backup-dir (concat "/tmp/emacs_backups/" (user-login-name) "/"))
(setq backup-directory-alist (list (cons "." backup-dir)))

;; disable menu bar
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
;; disable scroll bars
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
;; disable toolbars
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
;; disable tooltips
(if (fboundp 'tooltip-mode) (tooltip-mode -1))

;; don't show startup message
(setq inhibit-startup-message t)

;; don't bother about abbrev-file
(quietly-read-abbrev-file)

;; show line and column numbers
(line-number-mode t)
(column-number-mode t)

;; enable font-locking globally
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

;; set default tramp mode
(setq tramp-default-method "ssh")

;; use regexp while searching
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-s") 'isearch-forward-regexp)

;; enlarge and shrink windows (C-+/C-x -)
(global-set-key (kbd "C-+") 'enlarge-window)
(global-set-key (kbd "C-x -") 'shrink-window)

(global-set-key (kbd "C-c b") 'browse-url)

;; delete trailing whitespace before save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; windmove
(windmove-default-keybindings)

;; ido-mode
(setq ido-use-filename-at-point t)
(setq ido-enable-flex-matching t)
(ido-mode t)
(ido-everywhere t)
(add-hook 'ido-setup-hook 'custom-ido-extra-keys)
(defun custom-ido-extra-keys ()
  "Add my keybindings for ido."
  (define-key ido-completion-map "\C-n" 'ido-next-match)
  (define-key ido-completion-map "\C-p" 'ido-prev-match)
  (define-key ido-completion-map " "    'ido-exit-minibuffer))

;; add library dirs to load-path
(add-to-list 'load-path "~/.emacs.d/elisp")
(add-to-list 'load-path "~/.emacs.d/elisp/color-theme")
(add-to-list 'load-path "~/.emacs.d/elisp/ruby-mode")
(add-to-list 'load-path "~/.emacs.d/elisp/ri-emacs")
(add-to-list 'load-path "~/.emacs.d/elisp/yaml-mode")
(add-to-list 'load-path "~/.emacs.d/elisp/rinari")
(add-to-list 'load-path "~/.emacs.d/elisp/rinari/util")
(add-to-list 'load-path "~/.emacs.d/elisp/git-emacs")
(add-to-list 'load-path "~/.emacs.d/elisp/haml-mode")
(add-to-list 'load-path "~/.emacs.d/elisp/emacs-wget")
(add-to-list 'load-path "~/.emacs.d/elisp/ecb")
(add-to-list 'load-path "~/.emacs.d/elisp/cedet/common")
(add-to-list 'load-path "~/.emacs.d/elisp/erlang")
(add-to-list 'load-path "~/.emacs.d/elisp/distel/elisp")
(add-to-list 'load-path "~/.emacs.d/elisp/org-mode/lisp")
(add-to-list 'load-path "~/.emacs.d/elisp/org-mode/contrib/lisp")
(add-to-list 'load-path "~/.emacs.d/elisp/textmate.el")
(add-to-list 'load-path "~/.emacs.d/elisp/cucumber.el")
;; add more here as needed

;; org-mode
(require 'my-gtd)

;; emacs-wget
;; http://pop-club.hp.infoseek.co.jp/emacs/emacs-wget/emacs-wget-0.5.0.tar.gz
;; Download, uncompress and move to ~/.emacs.d/elisp/emacs-wget
;; run make
(autoload 'wget "wget" "wget interface for Emacs." t)
(autoload 'wget-web-page "wget" "wget interface to download whole web page." t)
(setq wget-download-directory-filter 'wget-download-dir-filter-regexp)
(setq wget-download-directory
      '(("\\.\\(jpe?g\\|png\\)$" . "~/Downloads/wget/pictures")
	("\\.el$" . "~/.emacs.d/elisp")
	("." . "~/Downloads/wget")))
(global-set-key (kbd "C-c w") 'wget)

;; icomplete
;; preview command completion when writing in Minibuffer
;; this is part of emacs
(icomplete-mode 1)

;; icomplete+
;; Extensions to icomplete
;; http://www.emacswiki.org/cgi-bin/wiki/download/icomplete+.el (wget)
(eval-after-load "icomplete" '(progn (require 'icomplete+)))

;; color-theme
;; http://download.gna.org/color-theme/color-theme-6.6.0.tar.gz (wget)
;; uncompress and move to ~/.emacs.d/elisp/color-theme
(require 'color-theme)
(color-theme-initialize)
;; http://edward.oconnor.cx/config/elisp/color-theme-hober2.el (wget)
(require 'color-theme-hober2)
(color-theme-hober2)

;; ruby-mode
;; ruby-mode from ruby-lang svn
;;
;; svn co http://svn.ruby-lang.org/repos/ruby/trunk/misc/ ~/.emacs.d/elisp/ruby-mode
(autoload 'ruby-mode "ruby-mode" "Mode for editing ruby source files" t)

;; inf-ruby
(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby" "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook '(lambda () (inf-ruby-keys) ))

;; ruby-electric
(require 'ruby-electric)
(add-hook 'ruby-mode-hook (lambda () (ruby-electric-mode t)))

;; ri-ruby
;; http://rubyforge.org/projects/ri-emacs/
;;
;; cd ~/.emacs.d/elisp
;; cvs -d :pserver:anonymous@rubyforge.org:/var/cvs/ri-emacs login # Press ENTER for password
;; cvs -d :pserver:anonymous@rubyforge.org:/var/cvs/ri-emacs checkout ri-emacs
;;
;; C-h r
(setq ri-ruby-script "/usr/bin/ri-emacs")
(autoload 'ri "ri-ruby" nil t)
(global-set-key (kbd "C-h r") 'ri)

;; ruby-test  run test/specs for ruby projects
;; http://www.emacswiki.org/cgi-bin/emacs/download/ruby-test.el (wget)
;;
;; C-x C-SPC => run this test/spec
;; C-x t     => run tests/specs in this file
;; C-c t     => toggle between specification and implementation
(require 'ruby-test)

;; rdebug from ruby-debug-extras-0.10.1 (not working as desire)
;;
;; Read http://groups.google.com/group/emacs-on-rails/browse_thread/thread/dfaa224905b51487
;; http://rubyforge.iasi.roedu.net/files/ruby-debug/ruby-debug-extra-0.10.1.tar.gz (wget)
(require 'rdebug)

;; rinari
;; http://github.com/eschulte/rinari
(require 'rinari)

(global-set-key (kbd "C-x C-M-f") 'rinari-find-file-in-project)
(setq rinari-browse-url-func 'browse-url-generic)

(setq auto-mode-alist (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode)) interpreter-mode-alist))
;; add file types to ruby-mode
;; (add-to-list 'auto-mode-alist '("\.treetop$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\.builder$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\.thor$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\.autotest$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\.rjs" . ruby-mode))

;; use exuberant-ctags
;;
;; Generate file with:
;;   ctags-exuberant -a -e -f TAGS --tag-relative -R app lib vendor
(setq rinari-tags-file-name "TAGS")

;; nXhtml
;; http://ourcomments.org/Emacs/nXhtml/doc/nxhtml.html
(load "~/.emacs.d/elisp/nxhtml/autostart.el")
(eval-after-load 'nxhtml
  '(define-key nxhtml-mode-map [f2] 'nxml-complete))
(setq nxhtml-global-minor-mode nil
      nxhtml-skip-welcome t
      nxhtml-default-encoding "utf8"
      rng-nxml-auto-validate-flag nil
      ;; indent-region-mode t
      ;; mumamo-chunk-coloring 'submode-colored
      ;; nxml-degraded t
      )
(add-to-list 'auto-mode-alist '("\\.html\\.erb\\'" . eruby-nxhtml-mumamo-mode))

;; (setq mumamo-map
;;       (let ((map (make-sparse-keymap)))
;;         (define-key map [(control meta prior)] 'mumamo-backward-chunk)
;;         (define-key map [(control meta next)]  'mumamo-forward-chunk)
;;         ;; (define-key map [tab] 'yas/expand)
;;         map))
;; (mumamo-add-multi-keymap 'mumamo-multi-major-mode mumamo-map)

;; haml-mode and & sass-mode
;; http://github.com/nex3/haml/
(require 'haml-mode)
(require 'sass-mode)
(add-to-list 'auto-mode-alist '("\.haml$" . haml-mode))
(add-to-list 'auto-mode-alist '("\.sass$" . sass-mode))

;; js2-mode (javascript IDE)
;; http://code.google.com/p/js2-mode/
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; yaml-mode
;; http://svn.clouder.jp/repos/public/yaml-mode/trunk/
(autoload 'yaml-mode "yaml-mode" "Yaml editing mode")
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-hook 'yaml-mode-hook
	  '(lambda () (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;; yasnippets
;; http://code.google.com/p/yasnippet/
(require 'yasnippet)
;; (add-to-list 'yas/extra-mode-hooks 'ruby-mode-hook)
(yas/initialize)
(setq yas/text-popup-function
      'yas/dropdown-list-popup-for-template)
(yas/load-directory "~/.emacs.d/snippets/defaults")
(yas/load-directory "~/.emacs.d/snippets/contrib-snippets")
(yas/load-directory "~/.emacs.d/snippets/yasnippets-rails/rails-snippets")
(yas/load-directory "~/.emacs.d/snippets/my-snippets")


;; git-emacs
;; http://github.com/tsgates/git-emacs
(require 'git-emacs)

;; textile-mode
;; http://dev.nozav.org/scripts/textile-mode.el
(require 'textile-mode)
(add-to-list 'auto-mode-alist '("\\.textile\\'" . textile-mode))

;; pastie
;; http://www.emacswiki.org/cgi-bin/wiki/download/pastie.el (wget)
(require 'pastie)

;; lorem-ipsum
;; http://www.emacswiki.org/cgi-bin/wiki/download/lorem-ipsum.el (wget)
(require 'lorem-ipsum)

;; tree-top
;; http://github.com/hornbeck/public_emacs/tree/master/treetop.el
(require 'treetop-mode)

;; po-mode
;; Part of the gettext package, you can grab it at http://gnuftp.spegulo.be/gettext/
;;
;; po-mode+
;; Adds some extensions to po-mode
;; http://www.emacswiki.org/cgi-bin/wiki/po-mode+.el/download/po-mode+.el (wget)
(autoload 'po-mode "po-mode+"
  "Major mode for translators to edit PO files" t)
(setq auto-mode-alist (cons '("\\.po\\'\\|\\.po\\." . po-mode)
			    auto-mode-alist))

;; (autoload 'po-find-file-coding-system "po-compat")
;; (modify-coding-system-alist 'file "\\.po\\'\\|\\.po\\."
;; 			    'po-find-file-coding-system)

;; CEDET
(load-file "~/.emacs.d/elisp/cedet/common/cedet.el")

;; ECB
;;
;; Emacs code browser
;; http://ecb.sourceforge.net
(require 'ecb)

;; Erlang mode
(require 'erlang-start)

;; Distel
;; erlang interactive mode
(require 'distel)
(distel-setup)

;; Gist support
;; http://github.com/defunkt/gist.el/raw/master/gist.el (wget)
(require 'gist)

;; w3m browser
;;
;; Homepage:
;; http://emacs-w3m.namazu.org/
;;
;; Download latest CVS code (for emacs 23):
;; cvs -d :pserver:anonymous@cvs.namazu.org:/storage/cvsroot login
;; cvs -d :pserver:anonymous@cvs.namazu.org:/storage/cvsroot co emacs-w3m
;;
;; Requirements:
;; wajig install w3m
;;
;; Compile:
;; ./configure
;; make
;; sudo make install
(require 'w3m-load)

;; CSV
;; http://www.emacswiki.org/emacs/download/csv-mode.el (wget)
;; (require 'csv-mode)

;; autotest support
;; http://www.emacswiki.org/cgi-bin/emacs/download/autotest.el (wget)
(setq autotest-use-ui t)
(require 'autotest)

;; Magit
;; http://zagadka.vm.bytemark.co.uk/magit/
(require 'magit)

;; rcodetools
;; http://eigenclass.org/hiki/rcodetools
;; (require 'rcodetools)

;; textmate minor mode
;; (require 'textmate)
;; (textmate-mode)

;; keep scrolling in compilation result buffer
(setq compilation-scroll-output t)

;; emacs-compile font-lock tweaks to get a pretty rspec result output
(add-to-list 'compilation-mode-font-lock-keywords
	     '("^\\([[:digit:]]+\\) examples?, \\([[:digit:]]+\\) failures?\\(?:, \\([[:digit:]]+\\) pendings?\\)?$"
	       (0 '(face nil message nil help-echo nil mouse-face nil) t)
	       (1 compilation-info-face)
	       (2 (if (string= "0" (match-string 2))
		      compilation-info-face
		    compilation-error-face))
	       (3 compilation-info-face t t)))

;; smart-compile
;; http://homepage.mac.com/zenitani/comp-e.html
(autoload 'smart-compile "smart-compile")
(setq smart-compile-alist
      '(("/programming/guile/.*c$" .    "gcc -Wall %f `guile-config link` -o %n")
        ("\\.c\\'"              .       "gcc -Wall %f -lm -o %n")
        ("\\.[Cc]+[Pp]*\\'"     .       "g++ -Wall %f -lm -o %n")
        ("\\.java$"             .       "javac %f")
	("_spec\\.rb$"          .       "spec %f")
	("\\.rb$"               .       "ruby %f")
	("\\.pl$"               .       "perl %f")
	("\\.js"                .       "jsl -process %f")
        (emacs-lisp-mode        .       (emacs-lisp-byte-compile))
        (html-mode              .       (browse-url-of-buffer))
        (html-helper-mode       .       (browse-url-of-buffer))
        ("\\.skb$"              .       "skribe %f -o %n.html")
        (haskell-mode           .       "ghc -o %n %f")
        (asy-mode               .       (call-interactively 'asy-compile-view))
        (muse-mode              .       (call-interactively 'muse-project-publish))))
(global-set-key (kbd "<f9>") 'smart-compile)

;; apache-mode
;; http://www.emacswiki.org/cgi-bin/wiki/download/apache-mode.el (wget)
(autoload 'apache-mode "apache-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.htaccess\\'"   . apache-mode))
(add-to-list 'auto-mode-alist '("httpd\\.conf\\'"  . apache-mode))
(add-to-list 'auto-mode-alist '("srm\\.conf\\'"    . apache-mode))
(add-to-list 'auto-mode-alist '("access\\.conf\\'" . apache-mode))
(add-to-list 'auto-mode-alist '("sites-\\(available\\|enabled\\)/" . apache-mode))

;; cucumber.el
(autoload 'feature-mode "feature-mode" "Mode for editing cucumber files" t)
(add-to-list 'auto-mode-alist '("\.feature$" . feature-mode))

(defun rinari-generate-tags()
  (interactive)
  (let ((my-tags-file (concat (rinari-root) "TAGS"))
	(root (rinari-root)))
    (message "Regenerating TAGS file: %s" my-tags-file)
    (if (file-exists-p my-tags-file)
	(delete-file my-tags-file))
    (shell-command
     (format "find %s -regex \".+rb$\" | xargs ctags-exuberant -a -e -f %s"
	     root my-tags-file))
    (if (get-file-buffer my-tags-file)
	 (kill-buffer (get-file-buffer my-tags-file)))
    (visit-tags-table my-tags-file)))
;; (add-hook 'rinari-minor-mode-hook 'rinari-generate-tags)

(defun haml-convert-rhtml-file (rhtmlFile hamlFile)
  "Convierte un fichero rhtml en un haml y abre un nuevo buffer"
  (interactive "fSelect rhtml file: \nFSelect output (haml) file: ")
  (let
      ((comando (concat "/usr/local/bin/html2haml -r " rhtmlFile " " hamlFile)))
    (shell-command comando)
    (find-file hamlFile)))

(defun haml-convert-region (beg end)
  "Convierte la región seleccionada a código haml"
  (interactive "r")
  (let ((comando "/usr/local/bin/html2haml -r -s"))
  (shell-command-on-region beg end comando (buffer-name) t)))

(defun haml-to-html-region (beg end)
  "Convierte la región seleccionada a código html"
  (interactive "r")
  (let ((comando "/usr/local/bin/haml -s -c"))
  (shell-command-on-region beg end comando (buffer-name) t)))


(defun haml-convert-buffer ()
  "Convierte el buffer seleccionado a código haml"
  (interactive)
  (let ((nuevoarchivo
	 (replace-regexp-in-string "erb$" "haml" (buffer-file-name))))
     (haml-convert-region (point-min) (point-max))
     (write-file nuevoarchivo)))

(defun sass-convert-region (beg end)
  "Convierte la región seleccionada a código sass"
  (interactive "r")
  (let ((comando "/usr/local/bin/css2sass -s"))
  (shell-command-on-region beg end comando (buffer-name) t)))

(defun sass-convert-buffer ()
  "Convierte el buffer seleccionado a código sass"
  (interactive)
  (let ((nuevoarchivo
	 (replace-regexp-in-string "css$" "sass" (buffer-file-name))))
     (sass-convert-region (point-min) (point-max))
     (write-file nuevoarchivo)))

;; Insert path
(defun insert-path (file)
 "insert file"
 (interactive "FPath: ")
 (insert (expand-file-name file)))

;; Poner los colorcitos lindos
(setq ansi-color-for-comint-mode t)

;; Modo de los ficheros de configuración de los TELES iSwitch
(add-to-list 'auto-mode-alist '("\.rou$" . shell-script-mode))
(add-to-list 'auto-mode-alist '("\.gbl$" . shell-script-mode))
(add-to-list 'auto-mode-alist '("defaulttab" . shell-script-mode))

;; Setting tab-width to 4 spaces
(setq tab-width 4)

;; Setting tab-width to 2 spaces in ruby-mode
(add-hook 'ruby-mode-hook (lambda () (setq tab-width 2)))

(setq debug-on-error nil)

;;;;;;;;;;;;;;;;;;;;;;;;;
;; CUSTOMIZATIONS FILE ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

(setq custom-file "~/.emacs.d/customizations.el")
(load custom-file 'noerror)


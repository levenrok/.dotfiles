;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Leven Rochana"
      user-mail-address "levenrok@proton.me")

(setq doom-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 17)
      doom-variable-pitch-font (font-spec :family "SF Pro Display" :size 14))
(setq doom-theme 'doom-tokyo-night)

(setq display-line-numbers-type 'relative)

(setq confirm-kill-emacs nil)


;; Keybindings
(map! :leader
      :desc "Toggle Treemacs" "e" #'+treemacs/toggle)
(map! :desc "Toggle VTerm"
      :n "C-`" #'+vterm/toggle)
(map! :desc "Search for files in the current directory"
      :n "C-p" #'find-file)
(map! :desc "Search for text in the current directory"
      :n "C-f" #'+default/search-project)


;; Org Mode
(setq org-directory "~/Developer/Org")

(custom-theme-set-faces!
  'doom-tokyo-night
  '(org-level-8 :inherit outline-3 :height 1.0)
  '(org-level-7 :inherit outline-3 :height 1.0)
  '(org-level-6 :inherit outline-3 :height 1.1)
  '(org-level-5 :inherit outline-3 :height 1.2)
  '(org-level-4 :inherit outline-3 :height 1.3)
  '(org-level-3 :inherit outline-3 :height 1.4)
  '(org-level-2 :inherit outline-2 :height 1.5)
  '(org-level-1 :inherit outline-1 :height 1.6)
  '(org-document-title :height 1.8 :bold t :underline nil))

(setq org-modern-table-vertical 1)
(setq org-modern-table t)
(add-hook 'org-mode-hook #'hl-todo-mode)


;; Packages
(after! treemacs
  (setq treemacs-persist-file nil)
  (setq treemacs-default-visit-action #'treemacs-visit-node-close-treemacs))

(custom-set-faces
 '(markdown-header-face ((t (:inherit font-lock-function-name-face :weight bold :family "variable-pitch"))))
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 1.6))))
 '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.5))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.4))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :height 1.3))))
 '(markdown-header-face-5 ((t (:inherit markdown-header-face :height 1.2))))
 '(markdown-header-face-6 ((t (:inherit markdown-header-face :height 1.1)))))

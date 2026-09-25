;; -*- lexical-binding: t; -*-

;;; eglot
(defun my-c-indent-settings ()
  (setq-local indent-tabs-mode nil)
  (setq-local tab-width 8)
  (setq-local c-basic-offset 8)
  (setq-local c-ts-indent-offset 8))

(add-hook 'c-mode-common-hook #'my-c-indent-settings)
(add-hook 'c-ts-mode-hook #'my-c-indent-settings)
(add-hook 'c++-ts-mode-hook #'my-c-indent-settings)

(let ((modes '(go-ts-mode
	       rust-ts-mode
	       python-ts-mode
	       c-ts-mode
	       c++-ts-mode)))
  (setopt treesit-enabled-modes modes)
  (dolist (mode modes) (add-hook (intern (format "%s-hook" mode)) #'eglot-ensure)))

;; 键位
(add-hook 'eglot-managed-mode-hook
	  (lambda ()
	    (local-set-key (kbd "C-c a") 'eglot-code-actions)
	    (local-set-key (kbd "C-c r") 'eglot-rename)
	    (local-set-key (kbd "C-c i") 'eglot-code-action-organize-imports)))

;;; apheleia 格式化
(use-package apheleia
  :ensure t
  :config
  (apheleia-global-mode 1)

  (global-set-key (kbd "C-c f") 'apheleia-format-buffer))

(provide '.emacs.lsp)

;行号
(global-display-line-numbers-mode)
(setq display-line-numbers-type 'absolute)

; 打开符号链接时不询问
(setq vc-follow-symlinks t)

; 包源
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

; 不要备份文件和自动保存
(setq make-backup-files nil)
(setq auto-save-default nil)

; 保存时自动删除行尾空格
(add-hook 'before-save-hook 'delete-trailing-whitespace)

; 系统剪贴板互通 (终端 Emacs 用 pbcopy/pbpaste)
(unless (display-graphic-p)
  (defun copy-to-osx (text)
    (with-temp-buffer
      (insert text)
      (call-process-region (point-min) (point-max) "pbcopy")))
  (defun paste-from-osx ()
    (with-output-to-string
      (call-process "pbpaste" nil standard-output)))
  (setq interprogram-cut-function 'copy-to-osx)
  (setq interprogram-paste-function 'paste-from-osx)
  (setq select-enable-clipboard t)
  (setq save-interprogram-paste-before-kill t))

; 互换 M-w(剪切) 和 C-w(复制)
(global-set-key (kbd "M-w") 'kill-region)
(global-set-key (kbd "C-w") 'kill-ring-save)

; 主题
(load-theme 'gruvbox t)
;; gruvbox 1.30.1 + Emacs 30: :background nil → unspecified
;; 有些 face 来自尚未加载的包，用 ignore-errors 跳过
(ignore-errors
  (dolist (face '(rainbow-delimiters-unmatched-face
                  diff-added diff-refine-added
                  diff-removed diff-refine-removed
                  whitespace-empty
                  js2-jsdoc-tag js2-jsdoc-type js2-jsdoc-value
                  js2-function-param js2-function-call
                  js2-instance-member js2-private-member
                  js2-private-function-call
                  js2-jsdoc-html-tag-name js2-jsdoc-html-tag-delimiter))
    (set-face-attribute face nil :background 'unspecified)))

; 终端鼠标支持
(xterm-mouse-mode 1)

; 自动配对括号引号
(electric-pair-mode 1)

; 缩进全用空格
(setq-default indent-tabs-mode nil)

; 补全 (minibuffer)
(ido-mode t)
(setq ido-enable-flex-matching t)

; vertico + consult（替代 ido）
(unless (package-installed-p 'vertico)
  (package-install 'vertico))
(unless (package-installed-p 'consult)
  (package-install 'consult))
(unless (package-installed-p 'marginalia)
  (package-install 'marginalia))
(unless (package-installed-p 'orderless)
  (package-install 'orderless))
(vertico-mode)
(marginalia-mode)
(setq completion-styles '(orderless basic)
      completion-category-defaults nil
      completion-category-overrides '((file (styles partial-completion))))
(savehist-mode)
(global-set-key [remap switch-to-buffer] 'consult-buffer)
(global-set-key (kbd "C-s") 'consult-line)
(global-set-key (kbd "C-S-s") 'consult-ripgrep)

; 代码补全 (corfu)
(unless (package-installed-p 'corfu)
  (package-install 'corfu))
(unless (package-installed-p 'corfu-terminal)
  (package-install 'corfu-terminal))
(setq corfu-auto t
      corfu-auto-delay 0.1
      corfu-auto-prefix 2
      corfu-quit-at-boundary t)
(global-corfu-mode)
(setq read-buffer-completion-ignore-case t
      read-file-name-completion-ignore-case t
      completion-ignore-case t)
(unless (display-graphic-p)
  (corfu-terminal-mode))

; 扩展选区
(unless (package-installed-p 'expand-region)
  (package-install 'expand-region))
(global-set-key (kbd "C-=") 'er/expand-region)
(global-set-key (kbd "C-M-=") 'er/contract-region)

; 彩虹括号
(unless (package-installed-p 'rainbow-delimiters)
  (package-install 'rainbow-delimiters))
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

; 多光标
(unless (package-installed-p 'multiple-cursors)
  (package-install 'multiple-cursors))
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)

; 高亮当前行
(global-hl-line-mode 1)

; 显示空格/Tab/换行
(global-set-key (kbd "C-c w") 'whitespace-mode)

; dired 文件管理器
(unless (package-installed-p 'nerd-icons-dired)
  (package-install 'nerd-icons-dired))
(add-hook 'dired-mode-hook 'nerd-icons-dired-mode)
(setq dired-listing-switches "-alh")
(setq dired-kill-when-opening-new-dired-buffer t)
(setq dired-dwim-target t)
(setq delete-by-moving-to-trash t)
(setq dired-use-ls-dired nil)

; 编译命令默认为空
(setq compile-command "")
(global-set-key (kbd "C-c c") 'compile)

; 编译输出支持 ANSI 颜色
(require 'ansi-color)
(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)


; C-o 在当前行下方开空行，光标移到新行
(defun open-line-below ()
  (interactive)
  (move-end-of-line 1)
  (newline-and-indent))
(global-set-key (kbd "C-o") 'open-line-below)

; treesitter 模式
(setq major-mode-remap-alist
      '((go-mode . go-ts-mode)
        (c-mode . c-ts-mode)
        (c++-mode . c++-ts-mode)
        (python-mode . python-ts-mode)
        (rust-mode . rust-ts-mode)
        (json-mode . json-ts-mode)
        (js-json-mode . json-ts-mode)
        (yaml-mode . yaml-ts-mode)
        (markdown-mode . markdown-ts-mode)))

; 自动安装 tree-sitter 语法
(setq treesit-language-source-alist
      '((go . ("https://github.com/tree-sitter/tree-sitter-go"))
        (c . ("https://github.com/tree-sitter/tree-sitter-c"))
        (cpp . ("https://github.com/tree-sitter/tree-sitter-cpp"))
        (python . ("https://github.com/tree-sitter/tree-sitter-python"))
        (rust . ("https://github.com/tree-sitter/tree-sitter-rust"))
        (php . ("https://github.com/tree-sitter/tree-sitter-php" "v0.23.5" "php"))
        (phpdoc . ("https://github.com/claytonrcarter/tree-sitter-phpdoc"))
        (html . ("https://github.com/tree-sitter/tree-sitter-html"))
        (css . ("https://github.com/tree-sitter/tree-sitter-css"))
        (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))
        (jsdoc . ("https://github.com/tree-sitter/tree-sitter-jsdoc"))
        (json . ("https://github.com/tree-sitter/tree-sitter-json"))
        (yaml . ("https://github.com/ikatyang/tree-sitter-yaml"))
        (markdown . ("https://github.com/tree-sitter-grammars/tree-sitter-markdown"))
        (zig . ("https://github.com/tree-sitter-grammars/tree-sitter-zig"))))

; ndjson 文件用 json-ts-mode
(add-to-list 'auto-mode-alist '("\\.ndjson\\'" . json-ts-mode))
(add-to-list 'auto-mode-alist '("\\.php\\'" . php-ts-mode))

; zig-ts-mode
(unless (package-installed-p 'zig-ts-mode)
  (package-install 'zig-ts-mode))
(add-to-list 'major-mode-remap-alist '(zig-mode . zig-ts-mode))
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs '((zig-ts-mode) . ("zls"))))
(add-hook 'zig-ts-mode-hook 'eglot-ensure)
(add-hook 'zig-ts-mode-hook (lambda () (setq-local compile-command "")))

; JSON 格式化
(defun json-format-buffer ()
  (interactive)
  (json-pretty-print (point-min) (point-max)))
(with-eval-after-load 'json-ts-mode
  (require 'json)
  (define-key json-ts-mode-map (kbd "C-c f") 'json-format-buffer))

; LSP (eglot 内置)
(add-hook 'go-ts-mode-hook 'eglot-ensure)
(add-hook 'go-ts-mode-hook (lambda () (setq-local eglot-report-progress nil)))
(add-hook 'python-ts-mode-hook 'eglot-ensure)
(add-hook 'rust-ts-mode-hook 'eglot-ensure)
(add-hook 'c-ts-mode-hook 'eglot-ensure)
(add-hook 'c-ts-mode-hook (lambda () (setq-local c-ts-mode-indent-offset 4)))
(add-hook 'c++-ts-mode-hook 'eglot-ensure)
(add-hook 'c++-ts-mode-hook (lambda () (setq-local c-ts-mode-indent-offset 4)))

; eglot 快捷键
(add-hook 'eglot-managed-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c a") 'eglot-code-actions)
            (local-set-key (kbd "C-c r") 'eglot-rename)
            (local-set-key (kbd "C-c f") 'eglot-format)
            (local-set-key (kbd "C-c i") 'eglot-code-action-organize-imports)))

; 向上/下移动当前行
(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (forward-line -2))
(defun move-line-down ()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

; 向上/下复制当前行
(defun duplicate-line-up ()
  (interactive)
  (save-excursion
    (move-beginning-of-line 1)
    (let ((line (buffer-substring (point) (line-end-position))))
      (forward-line -1)
      (open-line 1)
      (insert line))))
(defun duplicate-line-down ()
  (interactive)
  (save-excursion
    (move-beginning-of-line 1)
    (let ((line (buffer-substring (point) (line-end-position))))
      (forward-line 1)
      (open-line 1)
      (insert line))))

(global-set-key (kbd "M-<up>")    'move-line-up)
(global-set-key (kbd "M-<down>")  'move-line-down)
(global-set-key (kbd "M-S-<up>")  'duplicate-line-up)
(global-set-key (kbd "M-S-<down>") 'duplicate-line-down)

; Emacs 自定义
(setq custom-file "~/.emacs.custom.el")
(load custom-file)

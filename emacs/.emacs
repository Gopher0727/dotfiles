;; Custom 配置文件
(setq custom-file "~/.emacs.custom.el")
(load custom-file)

;; C-c r 配置热加载
(defun my-reload-config ()
  (interactive)
  (load (or user-init-file "~/.emacs")))
(global-set-key (kbd "C-c r") 'my-reload-config)

;; 启用鼠标支持
(unless (display-graphic-p)
  (xterm-mouse-mode 1))

;; 启用滚轮上下滑动
(require 'mwheel)
(dolist (ev '(wheel-up wheel-down))
  (global-set-key (vector ev) 'mwheel-scroll))

;; 终端下使用 macOS 系统剪贴板
(unless (display-graphic-p)
  (setq select-enable-clipboard t)
  ;; 复制到系统剪贴板
  (defun copy-to-osx (text)
    (with-temp-buffer
      (insert text)
      (call-process-region (point-min) (point-max) "pbcopy")))
  ;; 从系统剪贴板粘贴
  (defun paste-from-osx ()
    (with-output-to-string
      (call-process "pbpaste" nil standard-output)))
  (setq interprogram-cut-function 'copy-to-osx)
  (setq interprogram-paste-function 'paste-from-osx)
  (setq save-interprogram-paste-before-kill t))

;; 复制和剪切互换
(global-set-key (kbd "C-w") 'kill-ring-save)
(global-set-key (kbd "M-w") 'kill-region)

;; 删除光标位置到行首的内容
(defun kill-line-before ()
  (interactive)
  (kill-line 0))
(global-set-key (kbd "C-c k") 'kill-line-before)

;; 删除整行
(global-set-key (kbd "C-c d") 'kill-whole-line)

;; 在当前行上方/下方开新行
(defun open-line-above ()
  (interactive)
  (beginning-of-line)
  (newline)
  (previous-line))
(global-set-key (kbd "C-c o") 'open-line-above)
(defun open-line-below ()
  (interactive)
  (move-end-of-line 1)
  (newline-and-indent))
(global-set-key (kbd "C-o") 'open-line-below)

;; 选中整行
(defun mark-whole-line ()
  (interactive)
  (beginning-of-line)
  (set-mark (point))
  (end-of-line)
  (activate-mark))
(global-set-key (kbd "C-c l") 'mark-whole-line)

;; 移动当前行：M-<up> / M-<down>
(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (forward-line -2))
(defun move-line-down ()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))
(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)

;; 复制移动当前行：M-S-<up> / M-S-<down>
(defun duplicate-line-up ()
  (interactive)
  (save-excursion
    (let ((line (buffer-substring (line-beginning-position) (line-end-position))))
      (beginning-of-line)
      (insert line "\n"))))
(defun duplicate-line-down ()
  (interactive)
  (save-excursion
    (let ((line (buffer-substring (line-beginning-position) (line-end-position))))
      (end-of-line)
      (insert "\n" line))))
(global-set-key (kbd "M-S-<up>") 'duplicate-line-up)
(global-set-key (kbd "M-S-<down>") 'duplicate-line-down)

;; C-c ; 注释/取消注释当前行
(global-set-key (kbd "C-c ;") 'comment-line)

;; C-c b 注释/取消注释选中区域
(defun my-comment-block ()
  (interactive)
  (if (use-region-p)
      (comment-region (region-beginning) (region-end))))
(global-set-key (kbd "C-c b") 'my-comment-block)

;; 重新打开文件时，回到上次光标所在位置
(save-place-mode 1)

;; 选中内容后直接输入会替换选中内容
(delete-selection-mode t)

;; 文件被外部修改时自动 revert
(global-auto-revert-mode t)

;; 保存前删除行尾空格
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; 禁用备份文件
(setq make-backup-files nil)

;; 禁用自动保存
(setq auto-save-default nil)

;; 简短 yes/no 提示
(setq use-short-answers t)

;; 关闭菜单栏
(menu-bar-mode -1)

;; 高亮当前行
(global-hl-line-mode 1)

;; 状态栏显示行号和列号
;;(setq line-number-mode t)
(setq column-number-mode t)

;; 开启行号时，按当前 buffer 的最大行号计算宽度
(setq display-line-numbers-width-start t)
;; 显示（相对）行号
(global-display-line-numbers-mode)
;;(setq display-line-numbers-type 'relative)

;; 括号补全
(electric-pair-mode t)

;; compile 编译
(require 'compile)
(setq compile-command "")
(global-set-key (kbd "C-c c") #'compile)

;;; 包管理
;; 启用 Emacs 的 package.el
(require 'package)
;; 添加 Melpa 源
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; 初始化 package.el
(package-initialize)

;;; use-package 管理插件
(require 'use-package)
(setq use-package-always-ensure t)

;;; 主题
(use-package gruvbox-theme
  :config
  ;; 信任本地主题
  (setq custom-safe-themes t)
  (load-theme 'gruvbox t))

;;; corfu 补全
(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)      ; 输入后 0.1 秒弹出
  (corfu-auto-prefix 2)       ; 输入 2 个字符后开始补全
  (corfu-quit-at-boundary t)  ; 在单词边界自动关闭
  :config
  (global-corfu-mode))

;; 终端下额外启用 corfu-terminal
(use-package corfu-terminal
  :after corfu
  :if (not (display-graphic-p))
  :config
  (corfu-terminal-mode))

;;; minibuffer 补全
(use-package vertico
  :config
  (vertico-mode))

;;; apheleia 格式化
(use-package apheleia
  :config
  ;; 按语言指定格式化命令
  (setf (alist-get 'c-mode apheleia-mode-alist) '(clang-format))
  (setf (alist-get 'c++-mode apheleia-mode-alist) '(clang-format))
  (setf (alist-get 'go-mode apheleia-mode-alist) '(goimports))
  (setf (alist-get 'python-mode apheleia-mode-alist) '(ruff-isort ruff))
  (setf (alist-get 'rust-mode apheleia-mode-alist) '(rustfmt))
  (setf (alist-get 'sh-mode apheleia-mode-alist) '(shfmt))
  (setf (alist-get 'json-mode apheleia-mode-alist) '(jq))
  (setf (alist-get 'markdown-mode apheleia-mode-alist) '(prettier-markdown))
  ;; 格式化当前 buffer
  (global-set-key (kbd "C-c f") 'apheleia-format-buffer))

;; dired 图标字体支持
(use-package nerd-icons
  :defer t)
(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))
;; 让文件夹排在前面
(when (executable-find "gls")
  (setq insert-directory-program "gls")
  (setq dired-listing-switches "-alh --group-directories-first"))

;; orderless 模糊匹配
(use-package orderless
  :config
  (setq completion-styles '(orderless basic)
        completion-category-overrides '((file (styles partial-completion)))))

;;; eglot
(require 'eglot)
;; 选择模式打开文件
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-ts-mode))
;; 进入模式之后启动 eglot
(add-hook 'rust-ts-mode-hook 'eglot-ensure)
(add-hook 'python-ts-mode-hook 'eglot-ensure)
;; 当前模式使用的 LSP server
(add-to-list 'eglot-server-programs '(rust-ts-mode . ("rust-analyzer")))
(add-to-list 'eglot-server-programs '(python-ts-mode . ("pyright-langserver" "--stdio")))
;;; 其他配置
;; Python 缩进 4 格
(add-hook 'python-ts-mode-hook (lambda () (setq-local python-indent-offset 4)))

;; LSP 常用键位
(add-hook 'eglot-managed-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c a") 'eglot-code-actions)
            (local-set-key (kbd "C-c r") 'eglot-rename)
            (local-set-key (kbd "C-c i") 'eglot-code-action-organize-imports)))

;; 诊断列表
(global-set-key (kbd "C-c d") 'flymake-show-buffer-diagnostics)
(global-set-key (kbd "C-c D") 'flymake-show-project-diagnostics)

;; 关掉 hover 和 inlay hint
(setq eglot-ignored-server-capabilities '(:hoverProvider :inlayHintProvider))

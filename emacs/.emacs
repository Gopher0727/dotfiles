;; -*- lexical-binding: t; -*-

;; Custom 配置文件
(setq custom-file (expand-file-name "~/.emacs.custom.el"))
(load custom-file)

;; 包管理
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; 插件管理
(require 'use-package)

;; 主题
(use-package gruvbox-theme
  :ensure t
  :config
  (setq custom-safe-theme t)
  (load-theme 'gruvbox t))

;;; 基础配置
;; C-c r 配置热加载
(defun my-reload-config ()
  (interactive)
  (load (or user-init-file "~/.emacs")))
(global-set-key (kbd "C-c r") 'my-reload-config)

;; C-c c compile 编译
(require 'compile)
(setq compile-command "")
(global-set-key (kbd "C-c c") #'compile)
(require 'ansi-color)
(add-hook 'compilation-filter-hook #'ansi-color-compilation-filter)

;; 模糊匹配
(setq completion-styles '(flex basic))

;; 符号链接直达
(setq vc-follow-symlinks t)

;; 启用鼠标
(unless (display-graphic-p)
  (xterm-mouse-mode 1))

;; 启用滚轮上下滑动
(require 'mwheel)
(dolist (ev '(wheel-up wheel-down))
  (global-set-key (vector ev) 'mwheel-scroll))

;; 禁用自动保存
(setq auto-save-default nil)

;; 禁用备份文件
(setq make-backup-files nil)

;; 关闭菜单栏
(menu-bar-mode -1)

;; 自动加载变更
(global-auto-revert-mode t)

;; 高亮当前行
(global-hl-line-mode t)

;; 状态栏展示行列位置
(setq column-number-mode t)

;; 行号与相对行号
(global-display-line-numbers-mode)
(setq display-line-numbers-type 'relative)
(setq display-line-numbers-width-start t)

;; 简短 yes/no tis
(setq use-short-answers t)

;; 打开文件，回到上次光标位置
(save-place-mode t)

;; 选中内容后直接输入会替换选中内容
(delete-selection-mode t)

;; 外部修改会自动 revert
(global-auto-revert-mode t)

;; 保存时的操作
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;; 编辑
;; 复制和剪切互换
(global-set-key (kbd "C-w") 'kill-ring-save)
(global-set-key (kbd "M-w") 'kill-region)

;; 移动当前行
(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (forward-line -2))
(global-set-key (kbd "M-<up>") 'move-line-up)

(defun move-line-down ()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))
(global-set-key (kbd "M-<down>") 'move-line-down)

;; 复制当前行
(defun duplicate-line-up ()
  (interactive)
  (let ((column (current-column))
        (line (buffer-substring
               (line-beginning-position)
               (line-end-position))))
    (beginning-of-line)
    (insert line "\n")
    (forward-line -1)
    (move-to-column column)))
(global-set-key (kbd "M-S-<up>") #'duplicate-line-up)

(defun duplicate-line-down ()
  (interactive)
  (let ((column (current-column))
        (line (buffer-substring
               (line-beginning-position)
               (line-end-position))))
    (end-of-line)
    (insert "\n" line)
    (beginning-of-line)
    (move-to-column column)))
(global-set-key (kbd "M-S-<down>") #'duplicate-line-down)

;; 开新行
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

;; 注释
(global-set-key (kbd "C-c ;") 'comment-line)

(defun my-comment-block ()
  (interactive)
  (if (use-region-p)
      (common-region (region-beginning) (region-end))))
(global-set-key (kbd "C-c b") 'my-comment-block)

;;; 补全
;; 括号补全
(electric-pair-mode t)

;; minibuffer 补全
(fido-vertical-mode 1)

;; Corfu 补全
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  (corfu-quit-at-boundary t)
  :init
  (global-corfu-mode))

;;; Dired 文件管理
(setq dired-listing-switches "-alh --group-directories-first")

(defun my-dired-sort-dotfiles-first (orig-fun &rest args)
  "Use predictable name ordering for Dired directory listings."
  (let ((process-environment (copy-sequence process-environment)))
    (setenv "LC_ALL" "C.UTF-8")
    (apply orig-fun args)))

(with-eval-after-load 'dired  (unless (advice-member-p #'my-dired-sort-dotfiles-first
                           'dired-insert-directory)
    (advice-add 'dired-insert-directory :around
                #'my-dired-sort-dotfiles-first)))

(use-package nerd-icons-dired
  :ensure t
  :hook (dired-mode . nerd-icons-dired-mode))

;;; 加载 LSP 配置
(load "~/.emacs.lsp.el")

;;; 剪贴板互通
;; Macos：
(unless (display-graphic-p)
  (setq select-enable-clipboard t)
  (defun copy-to-osx (text)
    (with-temp-buffer
      (insert text)
      (call-process-region (point-min) (point-max) "pbcopy")))
  (defun paste-from-osx ()
    (with-output-to-string
      (call-process "pbpaste" nil standard-output)))
  (setq interprogram-cut-function 'copy-to-osx)
  (setq interprogram-paste-function 'paste-from-osx)
  (setq save-interprogram-paste-before-kill t))

;; WSL：
;; 终端模式下, Emacs 通过 OSC 52 转义序列把剪贴板内容发给终端，终端再同步到系统剪贴板。
;; Emacs 31 内置此支持, 但默认只对部分终端自动探测开启,
;; Ghostty 的 TERM 不在名单内, 且 tmux 分支默认只开 modifyOtherKeys, 故显式开启。
(use-package emacs
  :ensure nil
  :config
  (when (and (not (display-graphic-p))
             (eq system-type 'gnu/linux))
    (setq xterm-extra-capabilities '(setSelection getSelection modifyOtherKeys))
    (setq xterm-tmux-extra-capabilities '(setSelection getSelection modifyOtherKeys))
    (setq xterm-screen-extra-capabilities '(setSelection getSelection modifyOtherKeys))
    (setq tty-select-active-regions t)))

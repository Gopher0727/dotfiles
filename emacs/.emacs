;; -*- lexical-binding: t; -*-

;; Custom 配置文件
(setq custom-file (expand-file-name "~/.emacs.custom.el"))
(load custom-file)

;;; 包管理
(require 'package)
(setq package-archives '(("gnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

;;; 插件管理
(require 'use-package)

;;; 基础配置
;; 主题
(use-package gruvbox-theme
  :ensure t
  :config
  (setq custom-safe-theme t)
  (load-theme 'gruvbox t))

;; 当前窗口比例更大
(use-package golden-ratio
  :ensure t
  :custom
  (golden-ratio-auto-scale t)
  :config
  (golden-ratio-mode 1))

;; C-c r 配置热加载
(defun my-reload-config ()
  (interactive)
  (dolist (f '(.emacs.lsp .emacs.clipboard))
    (when (featurep f) (unload-feature f t)))
  (load (or user-init-file "~/.emacs")))
(global-set-key (kbd "C-c r") 'my-reload-config)

;; C-c c compile 编译
(require 'compile)
(global-set-key (kbd "C-c c") #'compile)

;; 终端颜色
(require 'ansi-color)
(add-hook 'compilation-filter-hook #'ansi-color-compilation-filter)

;;; 预览颜色值
(use-package colorful-mode
  :ensure t
  :config
  (global-colorful-mode 1))

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

;; 关闭折行
(setq-default truncate-lines t)
(setq window-sides-vertical nil)

;; 状态栏展示行列位置
(setq column-number-mode t)

;; 行号与相对行号
(global-display-line-numbers-mode)
(setq display-line-numbers-type 'relative)
(setq display-line-numbers-width-start t)

;; 简短 yes/no
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
(when (and (eq system-type 'darwin) (display-graphic-p))
  (global-set-key (kbd "C-w") 'kill-ring-save)
  (global-set-key (kbd "M-w") 'kill-region))

;;; 注释
;; 行注释
(global-set-key (kbd "C-c ;") 'comment-line)

;; 块注释
(defun my-comment-block ()
  (interactive)
  (if (use-region-p)
      (comment-dwim nil)))
(global-set-key (kbd "C-c b") 'my-comment-block)

;; 模糊匹配
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (orderless-smart-case t))

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

;;; Git
;; magit
(use-package magit
  :ensure t
  :bind
  ("C-c g" . magit-status))

;; gitsigns
(use-package git-gutter
  :ensure t
  :config
  (global-git-gutter-mode 1)
  (setq git-gutter:modified-sign "~"
        git-gutter:added-sign "+"
        git-gutter:deleted-sign "-"))

;;; 补全
;; 括号补全
(electric-pair-mode t)

;; minibuffer 补全
(use-package vertico
  :ensure t
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode 1))

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
(defun my-dired-sort-dotfiles-first (orig-fun &rest args)
  (let ((process-environment (copy-sequence process-environment)))
    (setenv "LC_ALL" "C.UTF-8")
    (apply orig-fun args)))
(with-eval-after-load 'dired
  (setq dired-listing-switches "-alh --group-directories-first")
  (setq dired-kill-when-opening-new-dired-buffer t)
  (unless (advice-member-p #'my-dired-sort-dotfiles-first 'dired-insert-directory)
    (advice-add 'dired-insert-directory :around #'my-dired-sort-dotfiles-first)))
(use-package nerd-icons-dired
  :ensure t
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package treemacs
  :ensure t
  :defer t
  :custom
  (treemacs-display-in-side-window t)
  (treemacs-position 'right)
  (treemacs-width 34)
  (treemacs-follow-after-init t)
  :config
  (treemacs-follow-mode 1))

(use-package imenu-list
  :ensure t
  :defer t
  :custom
  (imenu-list-position 'right)
  (imenu-list-size 0.35)
  (imenu-list-focus-after-activation nil)
  (imenu-list-update-current-entry t)
  (imenu-list-idle-update-delay 0.25)
  :config
  (add-to-list 'display-buffer-alist
               '("\\*Ilist\\*"
                 (display-buffer-in-side-window)
                 (side . right)
                 (slot . 1)
                 (window-width . 34)
                 (window-height . 0.35))))

(defun my-sidebar-toggle ()
  (interactive)
  (require 'treemacs)
  (require 'imenu-list)
  (let ((tree-window (treemacs-get-local-window))
        (outline-window (get-buffer-window "*Ilist*" t)))
    (if (or tree-window outline-window)
        (progn
          (when outline-window
            (with-current-buffer "*Ilist*"
              (imenu-list-quit-window)))
          (when (treemacs-get-local-window)
            (treemacs-quit)))
      (let ((source-buffer (current-buffer))
            (source-window (selected-window)))
        (treemacs-add-and-display-current-project-exclusively)
        (when (window-live-p source-window)
          (select-window source-window))
        (with-current-buffer source-buffer
          (imenu-list-smart-toggle))))))
(global-set-key (kbd "C-c e") #'my-sidebar-toggle)

;;; require
(add-to-list 'load-path (file-name-directory (or load-file-name buffer-file-name)))

(require '.emacs.lsp)
(require '.emacs.clipboard)

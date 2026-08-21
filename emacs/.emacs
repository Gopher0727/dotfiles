;; Custom 配置文件
(setq custom-file "~/.emacs.custom.el")
(load custom-file)

;; 重新打开文件时，回到上次光标所在位置
(save-place-mode 1)

;; C-c r 配置热加载
(defun my-reload-config ()
  (interactive)
  (load (or user-init-file "~/.emacs")))
(global-set-key (kbd "C-c r") 'my-reload-config)

;; 启用鼠标支持
(unless (display-graphic-p)
  (xterm-mouse-mode 1))

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
(defun kill-whole-line-anywhere ()
  (interactive)
  (kill-region (line-beginning-position) (line-beginning-position 2)))
(global-set-key (kbd "C-c K") 'kill-whole-line-anywhere)

;; 在当前行下方新开一行
(defun open-line-below ()
  (interactive)
  (move-end-of-line 1)
  (newline-and-indent))
(global-set-key (kbd "C-o") 'open-line-below)

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
(setq line-number-mode t)
(setq column-number-mode t)

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

;; 包管理 (MELPA)
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; customize 界面改的设置写入独立文件
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

;; 相对行号
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

;; Tab 键：行首缩进、文本中间插入 tab（原生默认是永远缩进）
(setq tab-always-indent nil)

;; 备份文件集中存放，不污染工作目录（file~ 备份 + #file# 自动保存）
(setq backup-directory-alist '(("." . "~/.emacs.d/backups/"))
      auto-save-file-name-transforms '((".*" "~/.emacs.d/backups/" t))
      auto-save-default t
      create-lockfiles nil)

;; 重新打开文件时光标回到上次的位置
(save-place-mode 1)

;; 重启 Emacs 后恢复上次打开的 buffer 和窗口布局
(desktop-save-mode 1)

;; 符号链接文件打开不询问
(setq vc-follow-symlinks t)

;; 终端鼠标支持：滚轮直接滚动屏幕（视口），而非光标移动
;; 需终端支持 XTerm 鼠标协议（ghostty/iTerm2 均支持）
(xterm-mouse-mode 1)

;; 上下滚轮显式绑定（覆盖 mwheel 自动安装，防止终端协议差异导致事件未绑定）
(require 'mwheel)
(dolist (ev '(wheel-up wheel-down mouse-4 mouse-5))
  (global-set-key (vector ev) 'mwheel-scroll))

;; 禁用鼠标横向滚动
(dolist (ev '(wheel-left wheel-right mouse-6 mouse-7))
  (global-set-key (vector ev) 'ignore))

;; 终端剪贴板：复制/剪切写入系统剪贴板，粘贴从系统剪贴板读
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

;; 主题 gruvbox
(unless (package-installed-p 'gruvbox-theme)
  (package-install 'gruvbox-theme))
(load-theme 'gruvbox t)

;; Treesitter grammars 自举，缺失时自动编译安装
(setq treesit-language-source-alist
      '((c "https://github.com/tree-sitter/tree-sitter-c")
        (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
        (go "https://github.com/tree-sitter/tree-sitter-go")
        (python "https://github.com/tree-sitter/tree-sitter-python")
        (rust "https://github.com/tree-sitter/tree-sitter-rust")
        (bash "https://github.com/tree-sitter/tree-sitter-bash")
        (json "https://github.com/tree-sitter/tree-sitter-json")
        (markdown "https://github.com/tree-sitter-grammars/tree-sitter-markdown"
                  nil "tree-sitter-markdown/src")
        (markdown-inline "https://github.com/tree-sitter-grammars/tree-sitter-markdown"
                         nil "tree-sitter-markdown-inline/src")))
(dolist (lang '(c cpp go python rust bash json markdown markdown-inline))
  (unless (treesit-language-available-p lang)
    (treesit-install-language-grammar lang)))

;; Treesitter 模式映射（c/cpp/rust/python/go/bash/json）+ C/C++ 4 空格缩进
(setq major-mode-remap-alist
      '((go-mode . go-ts-mode)
        (c-mode . c-ts-mode)
        (c++-mode . c++-ts-mode)
        (python-mode . python-ts-mode)
        (rust-mode . rust-ts-mode)
        (sh-mode . bash-ts-mode)
        (bash-ts-mode . bash-ts-mode)
        (json-mode . json-ts-mode)))
(add-hook 'c-ts-mode-hook (lambda () (setq-local c-ts-mode-indent-offset 4)))
(add-hook 'c++-ts-mode-hook (lambda () (setq-local c-ts-mode-indent-offset 4)))

;; Markdown：用 markdown-ts-mode 包（Emacs 无内置 ts 版）
(unless (package-installed-p 'markdown-ts-mode)
  (package-install 'markdown-ts-mode))
(require 'markdown-ts-mode)
(setq major-mode-remap-alist
      (append major-mode-remap-alist
              '((markdown-mode . markdown-ts-mode))))

;; LSP：eglot（C-c a 操作 / C-c r 重命名 / C-c i 整理导入）
;; 语言 → server：
;;	- c/cpp → clangd
;;	- rust → rust-analyzer
;;	- python → pyright
;;	- go → gopls
;;	- bash → bash-language-server
;;	- json → vscode-json-language-server
(dolist (mode '(c-ts-mode c++-ts-mode rust-ts-mode python-ts-mode go-ts-mode
			  bash-ts-mode json-ts-mode))
  (add-hook (intern (format "%s-hook" mode)) 'eglot-ensure))
(add-hook 'eglot-managed-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c a") 'eglot-code-actions)
            (local-set-key (kbd "C-c r") 'eglot-rename)
            (local-set-key (kbd "C-c i") 'eglot-code-action-organize-imports)))

;; 报错展示：关 hover/inlay hint，用下方列表（C-c d 文件 / C-c D 项目）
(setq eglot-ignored-server-capabilities '(:hoverProvider :inlayHintProvider))
(global-set-key (kbd "C-c d") 'flymake-show-buffer-diagnostics)
(global-set-key (kbd "C-c D") 'flymake-show-project-diagnostics)

;; 代码补全 corfu（终端自动切 corfu-terminal）
(unless (package-installed-p 'corfu)
  (package-install 'corfu))
(unless (package-installed-p 'corfu-terminal)
  (package-install 'corfu-terminal))
(setq corfu-auto t
      corfu-auto-delay 0.1
      corfu-auto-prefix 2
      corfu-quit-at-boundary t)
(global-corfu-mode)
(setq completion-ignore-case t
      read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t)
(unless (display-graphic-p)
  (corfu-terminal-mode))

;; minibuffer 补全：vertico + consult（C-x b / C-s / C-S-s）+ orderless
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

;; 格式化 apheleia：保存时自动 + C-c f 手动（与 nvim 一致）
(unless (package-installed-p 'apheleia)
  (package-install 'apheleia))
(require 'apheleia)
(setf (alist-get 'go-ts-mode apheleia-mode-alist) '(goimports))
(setf (alist-get 'python-ts-mode apheleia-mode-alist) '(ruff-isort ruff))
(setf (alist-get 'bash-ts-mode apheleia-mode-alist) '(shfmt))
(setf (alist-get 'json-ts-mode apheleia-mode-alist) '(jq))
(setf (alist-get 'markdown-ts-mode apheleia-mode-alist) '(prettier-markdown))
(apheleia-global-mode)
(global-set-key (kbd "C-c f") 'apheleia-format-buffer)

;; 代码折叠 treesit-fold（光标需在块内）
(unless (package-installed-p 'treesit-fold)
  (package-install 'treesit-fold))
(require 'treesit-fold)
(dolist (mode '(c-ts-mode c++-ts-mode rust-ts-mode python-ts-mode go-ts-mode
			  bash-ts-mode json-ts-mode))
  (add-hook (intern (format "%s-hook" mode)) 'treesit-fold-mode))
(global-set-key (kbd "C-c t") 'treesit-fold-toggle)
(global-set-key (kbd "C-c T") 'treesit-fold-close-all)
(global-set-key (kbd "C-c C-t") 'treesit-fold-open-all)

;; 缩进线 indent-bars（treesitter 树形缩进线）
(unless (package-installed-p 'indent-bars)
  (package-install 'indent-bars))
(require 'indent-bars)
(setq indent-bars-treesit-support t
      indent-bars-treesit-ignore-blank-lines-p t)
(dolist (mode '(c-ts-mode c++-ts-mode rust-ts-mode python-ts-mode go-ts-mode
			  bash-ts-mode json-ts-mode))
  (add-hook (intern (format "%s-hook" mode)) 'indent-bars-mode))

;; 彩色括号 rainbow-delimiters（按嵌套深度着色）
(unless (package-installed-p 'rainbow-delimiters)
  (package-install 'rainbow-delimiters))
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; Dired 增强（列表格式 / 废纸篓 / 图标）
(setq dired-listing-switches "-alh"
      dired-kill-when-opening-new-dired-buffer t
      dired-dwim-target t
      delete-by-moving-to-trash t
      dired-use-ls-dired nil)
(unless (package-installed-p 'nerd-icons-dired)
  (package-install 'nerd-icons-dired))
(add-hook 'dired-mode-hook 'nerd-icons-dired-mode)

;; Git 行号栏标记 diff-hl：修改/新增/删除行显示符号
(unless (package-installed-p 'diff-hl)
  (package-install 'diff-hl))
(require 'diff-hl)
(global-diff-hl-mode)
;; 终端下用 margin（行号栏旁）而非 fringe
(unless (display-graphic-p)
  (diff-hl-margin-mode))

;; 互换 C-w 和 M-w：C-w=复制，M-w=剪切（Emacs 默认相反）
(global-set-key (kbd "C-w") 'kill-ring-save)
(global-set-key (kbd "M-w") 'kill-region)

;; 删行首：C-c k（与 C-k 删行尾对称）
(defun kill-line-before ()
  "删除光标位置到行首的内容"
  (interactive)
  (kill-line 0))
(global-set-key (kbd "C-c k") 'kill-line-before)

;; 删整行：C-c K（含换行符，光标在行内任意位置）
(defun kill-whole-line-anywhere ()
  "删除光标所在整行（含换行符），光标在行内任意位置均有效"
  (interactive)
  (kill-region (line-beginning-position) (line-beginning-position 2)))
(global-set-key (kbd "C-c K") 'kill-whole-line-anywhere)

;; 开新行 C-o
(defun open-line-below ()
  (interactive)
  (move-end-of-line 1)
  (newline-and-indent))
(global-set-key (kbd "C-o") 'open-line-below)

;; 移动行 M-<up/down> / 复制行 M-S-<up/down>
(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (forward-line -2))
(defun move-line-down ()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))
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
(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)
(global-set-key (kbd "M-S-<up>") 'duplicate-line-up)
(global-set-key (kbd "M-S-<down>") 'duplicate-line-down)

;; 行注释 C-c ; / 块注释 C-c b（选中区域）
(global-set-key (kbd "C-c ;") 'comment-line)
(defun my-comment-block ()
  "注释或取消注释选中区域（块注释风格）"
  (interactive)
  (if (use-region-p)
      (comment-region (region-beginning) (region-end))
    (message "请先选中要注释的区域")))
(global-set-key (kbd "C-c b") 'my-comment-block)

;; 扩展选区 C-= / 收缩 C-M-=
(unless (package-installed-p 'expand-region)
  (package-install 'expand-region))
(global-set-key (kbd "C-=") 'er/expand-region)
(global-set-key (kbd "C-M-=") 'er/contract-region)

;; 多光标 multiple-cursors
(unless (package-installed-p 'multiple-cursors)
  (package-install 'multiple-cursors))
(require 'multiple-cursors)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)        ; 下一个相同词加光标
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)    ; 上一个相同词加光标
(global-set-key (kbd "C-c m") 'mc/edit-lines)               ; 选中多行后逐行光标
(global-set-key (kbd "C-c M") 'mc/mark-all-like-this)       ; 全部相同词加光标

;; 单词大小写 M-u / M-l / M-c（整词处理，区域优先）
(require 'thingatpt)
(defun my-upcase-word ()
  "大写光标所在单词；选中区域则大写区域"
  (interactive)
  (if (use-region-p)
      (upcase-region (region-beginning) (region-end))
    (let* ((bounds (bounds-of-thing-at-point 'word))
           (b (car bounds))
           (e (cdr bounds)))
      (upcase-region b e))))
(defun my-downcase-word ()
  "小写光标所在单词；选中区域则小写区域"
  (interactive)
  (if (use-region-p)
      (downcase-region (region-beginning) (region-end))
    (let* ((bounds (bounds-of-thing-at-point 'word))
           (b (car bounds))
           (e (cdr bounds)))
      (downcase-region b e))))
(defun my-capitalize-word ()
  "首字母大写光标所在单词；选中区域则处理区域"
  (interactive)
  (if (use-region-p)
      (capitalize-region (region-beginning) (region-end))
    (let* ((bounds (bounds-of-thing-at-point 'word))
           (b (car bounds))
           (e (cdr bounds)))
      (capitalize-region b e))))
(global-set-key (kbd "M-u") 'my-upcase-word)
(global-set-key (kbd "M-l") 'my-downcase-word)
(global-set-key (kbd "M-c") 'my-capitalize-word)

;; 编译：M-x compile / C-c c（命令手动填写）
(setq compile-command "")
(global-set-key (kbd "C-c c") 'compile)

;; 热加载配置：C-c C-r（改完 .emacs 立即生效，无需重启）
(defun my-reload-config ()
  "重新加载本配置文件，使修改立即生效"
  (interactive)
  (load (or user-init-file "~/.emacs")))
(global-set-key (kbd "C-c C-r") 'my-reload-config)

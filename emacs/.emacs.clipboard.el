;;; -*- lexical-binding: t; -*-

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

(provide '.emacs.clipboard)

;;; shexc-mode.el --- mode for ShExC

;; Copyright (c) 2003-2007 Hugo Haas <hugo@larve.net>
;; re-worked and re-published by kurtjx (c) 2010 <kurtjx@gmail.com>
;; repurposed fro ShExC (c) 2015 <eric@w3.org>

;; For documentation on ShExC, see:
;; https://www.w3.org/2014/03/ShEx-subm/Primer

;;; Comentary:

;; Goals:
;; - sytax highlighting
;; - completion
;; - indentation

;; What it does now:
;; - Syntax highlighting
;; - comment/uncomment block with M-;

;;; Code:

;; the command to comment/uncomment text
(defun shexc-comment-dwim (arg)
"Comment or uncomment current line or region in a smart way.
For detail, see `comment-dwim'."
   (interactive "*P")
   (require 'newcomment)
   (let ((deactivate-mark nil) (comment-start "#") (comment-end ""))
     (comment-dwim arg)))

(setq shexc-highlights
  '(("\\(prefix\\|PREFIX\\|start\\|START\\)\\>" 1 font-lock-keyword-face t) ; how to do case insensitive?
    ("\\([.?*+&]\\)" 1 font-lock-keyword-face t)
    ("\\<\\(a\\)\\>" 1 font-lock-keyword-face t)
    ;("\\(\\(?:[a-zA-Z0-9_]+\\):\\)" 1 font-lock-type-face t)
    ;(":\\(\\(?:[a-zA-Z0-9_]+\\)\\)[ ;.)?+*,#\n]" 1 font-lock-constant-face t)

    ("\\(\\(?:[a-zA-Z0-9_]\\)*:\\)\\(?:[a-zA-Z0-9_]\\)*" 1 font-lock-type-face t)
    ("\\(?:[a-zA-Z0-9_]\\)*:\\(\\(?:[a-zA-Z0-9_]\\)*\\)" 1 font-lock-constant-face t)

    ("\\(<.*?>\\)" 1 font-lock-function-name-face t)

    ; @SP*<Shape> | &SP*<Shape>
    ("\\([@&]\\(?:[ \n\t]*\\|#\\S-*?\n\\)*<.*?>\\)" 1 font-lock-preprocessor-face t)
    ; @SP*my:Shape | &SP*my:Shape
    ("\\([@&]\\(?:[ \n\t]*\\|#\\S-*?\n\\)*\\(?:[a-zA-Z0-9_]+\\):\\(?:[a-zA-Z0-9_]+\\)\\)" 1 font-lock-preprocessor-face t)
    ; <Shape>SP*{...}
    ("\\(<.*?>\\)[ \n\t]*{" 1 font-lock-preprocessor-face t)
    ; my:ShapeSP*{...}
    ("\\(\\(?:[a-zA-Z0-9_]+\\):\\(?:[a-zA-Z0-9_]+\\)\\)[ \n\t]*{" 1 font-lock-preprocessor-face t)
    ; start=SP*<Shape>
    ("start[ \n\t]*=[ \n\t]*\\(<.*?>\\)" 1 font-lock-preprocessor-face t)
    ; start=SP*my:Shape
    ("start[ \n\t]*=[ \n\t]*\\(\\(?:[a-zA-Z0-9_]\\)*:\\(?:[a-zA-Z0-9_]\\)*\\)" 1 font-lock-preprocessor-face t)

    ("\\(\\\".*?\\\"\\)" 1 font-lock-string-face t)
    ; Bug: some trailing characters are highlighted; restricting comments regexp
    ; ("\\(#.*\\)" 1 font-lock-comment-face t)
    ("^\\s-*\\(#.*\\)" 1 font-lock-comment-face t)

    ; semantic actions
    ("\\(%\\(?:[a-zA-Z0-9_-]*\\){\\(?:[ -$&-Z^-�]\\|\\[\\|\\]\\|\\\\%\\)+%}\\)" 1 font-lock-preprocessor-face t); stolen from n3 mode, but what is it?
    )
)

;;(define-generic-mode 'shexc-mode
(define-derived-mode shexc-mode fundamental-mode
  ;; setup tab key not working :/
  ;;(setq c-basic-offset 4)

  ;; syntax highlighting
  (setq font-lock-defaults '(shexc-highlights))

  ;; modify the keymap M-; comments/uncomments region
  (define-key shexc-mode-map [remap comment-dwim] 'shexc-comment-dwim)
  ;; comments: “# ...”
  (modify-syntax-entry ?# "< b" shexc-mode-syntax-table)
  (modify-syntax-entry ?\n "> b" shexc-mode-syntax-table)

  ;; description
  "Mode for Notation 3 documents."
)


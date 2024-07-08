;;; clang-format-lite.el --- Format code on-save with clang-format, supports remote files

;; Copyright (C) 2024 Arteen Abrishami

;; Author: Arteen Abrishami <arteen@ucla.edu>
;; Maintainer: Arteen Abrishami <arteen@ucla.edu>
;; URL: https://github.com/arteen1000/clang-format-lite
;; Version: 0.0.1
;; Package-Requires ((emacs "24.1"))
;; Keywords: tools, c, c++, clang-format, formatting

;; This file is not a part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; This package primarily provides two public interfaces
;; (1) `clang-format-lite-save-hook'
;; (2) `clang-format-lite-only-if-config'
;; In conjunction, they allow the user to adjust `clang-format-lite' to their needs.
;; `clang-format-lite' permits formatting on-save for both remote and local files.
;; See the README for more details.

;;; Code:

(defgroup clang-format-lite nil
  "Clang format for remote/local files with customizable save hook."
  :group 'tools)

(defcustom clang-format-lite-only-if-config nil
  "Determines whether clang-format-lite-save-hook should run `clang-format'.

Possible values: nil, non-nil
nil: `clang-format' always runs when hook is attached
non-nil: `clang-format' runs only when \".clang-format\" file is found"
  
  :type 'boolean
  :group 'clang-format-lite)

(defun clang-format-lite-on-disk ()
  "Run `clang-format' in-place on the current buffer's file on disk if it exists."
  (let ((full-path (buffer-file-name)))
    (when full-path
      (let ((filename (file-relative-name full-path)))
        (process-file "clang-format" nil nil nil "-i" filename)
        (revert-buffer t t)))))

(defun clang-format-lite-save-hook ()
  "Hook to `clang-format' local/remote files on save with configuration option."
  (add-hook 'after-save-hook
            (lambda ()
              (if clang-format-lite-only-if-config
                  (when (locate-dominating-file "." ".clang-format")
                    (clang-format-lite-on-disk))
                (clang-format-lite-on-disk))
              nil) -99 t))

(provide 'clang-format-lite)
;;; clang-format-lite.el ends here

;;; melrose-font-lock.el --- Font locking module for Melrose Mode -*- lexical-binding: t -*-

;; Copyright (C) 2022 reach@martinzacho.com

;; Author: Martin Zacho
;; Homepage: https://github.com/mzacho/melrose-for-emacs
;; Version: 0
;; Package-Version: 0.0.0
;; Package-Commit: 
;; Keywords: music
;; Package-Requires: ()

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; notes from hsc3:
;; This mode is implemented as a derivation of `haskell' mode,
;; indentation and font locking is courtesy that mode.  The
;; inter-process communication is courtesy `comint'.  The symbol at
;; point acquisition is courtesy `thingatpt'.  The directory search
;; facilities are courtesy `find-lisp'.

;;; Code:

(require 'font-lock)

;;;###autoload
(defgroup melrose-appearance nil
  "Melrose Appearance."
  :group 'melrose)

(provide 'melrose-font-lock)

;;; melrose-font-lock.el ends here

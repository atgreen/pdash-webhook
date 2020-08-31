;;; -*- Mode: LISP; Syntax: COMMON-LISP; Base: 10 -*-
;;;
;;; Copyright (C) 2020  Anthony Green <green@moxielogic.com>
;;;                         
;;; pdash-webhook is free software; you can redistribute it and/or
;;; modify it under the terms of the GNU General Public License as
;;; published by the Free Software Foundation; either version 3, or
;;; (at your option) any later version.
;;;
;;; pdash-webhook is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;; General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with pdash-webhook; see the file COPYING3.  If not see
;;; <http://www.gnu.org/licenses/>.

(asdf:defsystem #:pdash-webhook
  :description "This is my pdash-webhook template."
  :author "Anthony Green <green@moxielogic.com>"
           :version "0"
  :serial t
  :components ((:file "package")
	       (:file "pdash-webhook"))
  :depends-on (:hunchentoot :cl-stomp))


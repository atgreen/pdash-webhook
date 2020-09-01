;;; -*- Mode: LISP; Syntax: COMMON-LISP; Package: PDASH-WEBHOOK; Base: 10 -*-
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

;; Top level for pdash-webhook

(in-package :pdash-webhook)

;; Our server....

(defvar *hunchentoot-server* nil)

(defvar *default-port-string* "8080")

(defvar *stomp* nil)
(defparameter *amq-host* "amq-broker")

;; Start the web app.

(defun start-pdash-webhook ()
  "Start the web application and start the AMQ connection."
  (format t "** Starting hunchentoot on 8080~%")
  (setf hunchentoot:*show-lisp-errors-p* t)
  (setf hunchentoot:*show-lisp-backtraces-p* t)
  (setf *stomp* (stomp:make-connection *amq-host* 61612))
  (setq *hunchentoot-server* (hunchentoot:start 
			      (make-instance 'hunchentoot:easy-acceptor 
					     :port 8080)))
  (stomp:start *stomp*))

(defun stop-pdash-webhook ()
  "Stop the web application."
  (hunchentoot:stop *hunchentoot-server*))

(defvar *username* "myusername")
(defvar *password* "mypassword")

(defmacro with-http-authentication (&rest body)
  `(multiple-value-bind (username password) (hunchentoot:authorization)
     (cond ((and (string= username *username*) (string= password *password*))
            ,@body)
           (t (hunchentoot:require-authorization "pdash-webhook")))))

(EVAL-WHEN (:COMPILE-TOPLEVEL :LOAD-TOPLEVEL :EXECUTE)

  (hunchentoot:define-easy-handler (say-yo :uri "/yo") (name)
    (with-http-authentication
	(setf (hunchentoot:content-type*) "text/plain") 
      (print (hunchentoot:post-parameters*))
      (let ((data (hunchentoot:raw-post-data :request hunchentoot:*request*)))
	(when data
	  (stomp:post *stomp* (sb-ext:octets-to-string data) "/topic/tower-notification")
	  (format t (sb-ext:octets-to-string data))
	  (format nil (sb-ext:octets-to-string data))))))

  (hunchentoot:define-easy-handler (status :uri "/status") ()
    (setf (hunchentoot:content-type*) "text/plain")
    (format nil "It's all good"))

  )


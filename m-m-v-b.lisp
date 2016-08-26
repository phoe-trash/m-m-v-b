;;;; MULTIPLE-MULTIPLE-VALUE-BIND
;;;; © Michał "phoe" Herda 2016
;;;; m-m-v-b.lisp

(defpackage #:m-m-v-b
  (:use #:cl)
  (:export #:m-m-v-b
           #:multiple-multiple-value-bind))

(in-package #:m-m-v-b)

(defmacro m-m-v-b (pairs &body body)
  `(multiple-multiple-value-bind ,pairs ,@body))

(defmacro multiple-multiple-value-bind (pairs &body body)
  (%m-m-v-b pairs body))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defun %m-m-v-b (pairs &rest body)
    (when (null (cadr pairs)) (error "Odd amount of arguments passed to M-M-V-B."))
    (destructuring-bind (vars value-form . pairs) pairs 
      `(multiple-value-bind ,vars ,value-form
         ,(if (null pairs)
              (caar body)
              (%m-m-v-b pairs (car body)))))))

(defun m-m-v-b-test ()
  (flet ((foo () (values 1 2 3))
         (bar () (values 4 5 6))
         (baz () (values 7 8 9)))
    ;; TEST 1 - proper work
    (flet ((test () (m-m-v-b ((a b c) (foo)
                              (d e f) (bar)
                              (g h i) (baz))
                      (list a b c d e f g h i))))
      (unless (equal (test) '(1 2 3 4 5 6 7 8 9))
        (error "M-M-V-B test 1 failed.")))
    ;; TEST 2 - error signaling
    (handler-case
        (progn (%m-m-v-b '((a b c) (foo)
                           (d e f) (bar)
                           (g h i)))
               (error "M-M-V-B test 2 failed."))
      (error ()))))

;;;; package.lisp

(defpackage #:eigen
  (:use #:cl)
  (:export #:security
	   #:*reference-stocks-2020*
	   #:with-securities-list
	   #:market-order
	   #:portfolio-state))

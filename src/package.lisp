;;;; package.lisp

(uiop:define-package #:eigen (:use #:cl #:40ants-doc)
  (:documentation "The main package for Eigen, including all core utilites.")
  
  (:export

   ;; security.lisp
   #:security
   #:with-securities-list

   ;;portfolio.lisp
   #:market-order
   #:portfolio-state

   ;; util.lisp
   #:join-frame
   
   ;; plotting.lisp
   #:plot-security
   
   ;; example-data.lisp
   #:load-example-data))

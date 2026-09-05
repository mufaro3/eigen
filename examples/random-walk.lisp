;;;; random-walk.lisp
;;;;
;;;; Performs entirely random trades on the stock market across
;;;; several portfolios using the 

(in-package #:eigen)

(defparameter *reference-stocks-2020* (load-example-data 10))
(plot-securities-list *reference-stocks-2020*)

(defparameter *first-stock* (first *reference-stocks-2020*))
(plot-security *first-stock* :metric 'high)

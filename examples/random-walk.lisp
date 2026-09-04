;;;; random-walk.lisp
;;;;
;;;; Performs entirely random trades on the stock market across
;;;; several portfolios using the 

(in-package #:eigen)

(defparameter *reference-stocks-2020* (load-example-data 10))
;; (defparameter *unified-table* (join-frame *reference-stocks-2020* :metric 'close))

(defparameter *first-stock* (first *reference-stocks-2020*))
(plot-security *first-stock* :metric 'close :end 100)

(with-securities-list (date ticker name price price-history *reference-stocks-2020*
		       :value-metric 'close :max-days 10)
  (format t "~A ~A ~F~%" ticker date price))

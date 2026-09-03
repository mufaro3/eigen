;;;; random-walk.lisp
;;;;
;;;; Performs entirely random trades on the stock market across
;;;; several portfolios using the 

(in-package #:eigen)

(with-securities-list (index date *reference-stocks-2020*)
  (print date)
  (sb-ext:quit))

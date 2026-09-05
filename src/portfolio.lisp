(in-package #:eigen)
(defsection @eigen-portfolio (:title "Portfolio")
  "Portfolio management (i.e. a list of positions, performing market orders, etc.)"
  (market-order structure)
  (portfolio-state structure))

(defstruct market-order
  "types of market orders (BUY/SELL, symbol, quantity)"
  (type     nil :type symbol)
  (ticker   nil :type symbol)
  (quantity nil :type integer)
  (date     nil :type date))

(defstruct portfolio
  "naive buy/sell portfolio only"
  (cash-balance   *default-portfolio-balance* :type integer)
  (positions-held nil :type (list-of security))
  (past-orders    nil :type (list-of market-order))
  (pending-orders nil :type (list-of market-order))
  (date           nil :type date))

(defun portfolio-total-value (p &key (metric 'close))
  "Computes the total value of the portfolio (cash plus holdings)."
  (declare (type portfolio p)
	   (type symbol metric))
  (the float
       (flet ((security->value (s)
		(declare (type security s))
		(security-value s (portfolio-date p) :metric metric)))
	 (+ (postfolio-cash-balance p)
	    (mapcar #'+ (mapcar #'security->value (portfolio-positions-held p)))))))

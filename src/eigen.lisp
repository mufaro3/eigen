;;;; eigen.lisp

(in-package #:eigen)

;; general data struct containing the only data particularly necessary
(defstruct security symbol etf? name data-filepath data)

;; reference data from 1980 to 2020 from the Kaggle Stocks dataset
;; https://www.kaggle.com/datasets/jacksoncrow/stock-market-dataset?resource=download
(defparameter *reference-stocks-2020*
  (let* ((historical-market-data-folder "/home/moofy/Programming/eigen/historical-market-data/")
	 (hmd-directory-csv (uiop:subpathname historical-market-data-folder "symbols_valid_meta.csv"))
	 (hmd-stocks-data (uiop:subpathname historical-market-data-folder "stocks/"))
	 (hmd-etfs-data (uiop:subpathname historical-market-data-folder "etfs/"))
	 (directory (lisp-stat:read-csv hmd-directory-csv)))
    (loop :for i :from 0 :below (lisp-stat:nrow directory)
	  :collect
	  (let* ((entry (lisp-stat:select directory i t))
		 (is-etf (string-equal "Y" (lisp-stat:select entry 'etf)))
		 (ticker-symbol (lisp-stat:select entry 'symbol))
		 (relevant-data-dir (if is-etf hmd-etfs-data hmd-stocks-data))
		 (data-filepath (uiop:subpathname relevant-data-dir (format nil "~A.csv" ticker-symbol))))
	    (make-security :symbol ticker-symbol
			   :etf? is-etf
			   :name (lisp-stat:select entry 'security-name)
			   :data-filepath data-filepath
			   :data (lisp-stat:read-csv data-filepath))))))

;; simple macro for iterating timewise over the datasets
(defmacro with-securities-list ((index date series-list) &body body)
  `(loop :for ,index :below (lisp-stat:nrow (first securities-list))
	 :do (progn (setq day (lisp-stat:select (first securities-list) 'date)) ,@body)))

;; types of market orders (BUY/SELL, symbol, quantity)
(defstruct market-order type symbol quantity)

;; naive buy/sell portfolio only
(defstruct portfolio-state cash-balance purchased-securities total-value orders)

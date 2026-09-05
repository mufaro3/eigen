(in-package #:eigen)
(defsection @eigen-example-data (:title "Example Data")
  "Used for loading example stock data from the Kaggle stocks dataset."
  (load-example-data function))

(defun load-example-data (number-securities)
  "Loads the reference data from 1980 to 2020 from the Kaggle Stocks dataset.
   https://www.kaggle.com/datasets/jacksoncrow/stock-market-dataset"
  (the (list-of security)
       (let* ((historical-market-data-folder
		"/home/moofy/Programming/eigen/historical-market-data/")
	      (hmd-directory-csv
		(uiop:subpathname historical-market-data-folder
				  "symbols_valid_meta.csv"))
	      (hmd-stocks-data
		(uiop:subpathname historical-market-data-folder
				  "stocks/"))
	      (hmd-etfs-data
		(uiop:subpathname historical-market-data-folder "etfs/"))
	      (directory (lisp-stat:read-csv hmd-directory-csv)))
	 (loop :for i :in (random-sample-indices
			   number-securities (lisp-stat:nrow directory))
	       :collect
	       (let* ((entry (lisp-stat:select directory i t))
		      (is-etf (string-equal "Y" (lisp-stat:select entry 'etf)))
		      (ticker-symbol (lisp-stat:select entry 'symbol))
		      (relevant-data-dir (if is-etf hmd-etfs-data hmd-stocks-data))
		      (data-filepath
			(if (string-equal "AGM$A" ticker-symbol)
			    (uiop:subpathname relevant-data-dir "AGM-A.csv")
			    (uiop:subpathname
			     relevant-data-dir
			     (format nil "~A.csv" ticker-symbol)))))
		 (make-security :ticker ticker-symbol
				:type (if is-etf 'etf 'stock)
				:name (lisp-stat:select entry 'security-name)
				:data-filepath data-filepath
				:data (lisp-stat:read-csv data-filepath)))))))

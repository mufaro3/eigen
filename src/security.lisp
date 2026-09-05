(in-package #:eigen)
(defsection @eigen-security (:title "Securities")
  "Security definition (i.e. data management)."
  (security structure)
  (secuirty-value function)
  (pack-securities-list function)
  (with-securities-list macro))

(defstruct security
  "General data struct containing the only data particularly necessary."
  (ticker        nil :type string)
  (type          nil :type symbol)
  (name          nil :type string)
  (data-filepath nil :type pathname)
  (data          nil :type lisp-stat:data-frame))

(defun security-value (security date &key (metric 'close))
  "Looks up the value of the security along a
   given metric on a specific date"
  (declare (type security security)
	   (type date date)
	   (type symbol metric))
  (let ((dates (lisp-stat:select (security-data security) :date))
	(date-index (position (date->string date) dates :test #'string-equal)))
    (when date-index
      (lisp-stat:select (security-data security) date-index metric))))

(defun pack-securities-list-old (securities-list &key (metric 'close))
  "Packs a list of securities' data for plotting."
  (declare (type (list-of security) securities-list)
	   (type symbol metric))
  (the lisp-stat:data-frame
       (let ((output-table-header `(ticker date ,metric))
	     (output-table-rows   `(#() #() #())))
	 (progn
	   (dolist (security securities-list)
	     (lisp-stat:do-rows (security-data security) `(date ,metric)
	       (lambda (date metric-value)
		 (let ((row-data (vector (security-ticker security)
					 date metric-value)))
		   (setq output-table
			 (lisp-stat:stack-rows output-table-rows row-data))))))
	   (lisp-stat:make-df output-table-header
			      output-table-rows)))))

(defun pack-securities-list (securities-list &key (metric 'close))
  "Packs a list of securities' data for plotting."
  (declare (type (list-of security) securities-list)
           (type symbol metric))
  (let ((rows '()))
    (dolist (security securities-list)
      (lisp-stat:do-rows (security-data security) `(date ,metric)
        (lambda (date metric-value)
          (push (vector (security-ticker security)
                        date
                        metric-value)
                rows))))
    (setf rows (nreverse rows))
    (lisp-stat:make-df
     `(ticker date price)
     (list
      (map 'vector (lambda (row) (aref row 0)) rows)
      (map 'vector (lambda (row) (aref row 1)) rows)
      (map 'vector (lambda (row) (aref row 2)) rows)))))

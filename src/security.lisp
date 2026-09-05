(in-package #:eigen)
(defsection @eigen-security (:title "Securities")
  "Security definition (i.e. data management)."
  (security structure)
  (secuirty-value function)
  (pack-securities-list function)
  (with-securities-list macro))

(defstruct security
  "General data struct containing the only data particularly necessary."
  (ticker :type symbol)
  (type :type symbol)
  (name :type string)
  (data-filepath :type string)
  (data :type lisp-stat:data-frame))

(defun security-value (security date (metric 'close))
  "Looks up the value of the security along a
   given metric on a specific date"
  (declare (type security security)
	   (type date date)
	   (type symbol metric))
  (let ((dates (lisp-stat:select (security-data security) :date))
	(date-index (position (date->string date) dates :test #'string-equal)))
    (when date-index (lisp-stat:select (security-data security) date-index metric))))

(defun pack-securities-list (securities-list &key metric)
  "Packs a list of securities' data for plotting."
  (declare (type (list-of security) securities-list)
	   (type symbol metric))
  (the lisp-stat:data-frame
       (let ((output-table (lisp-stat:make-df '("ticker" "date" ,metric) '(#() #() #()))))
	 (progn
	   (dolist (security securities)
	     (lisp-stat:do-rows (security-data security) '("date" ,metric)
	       (lambda (date metric-value)
		 (let ((row-data (vector (security-ticker security) date metric-value)))
		   (setq output-table (stack-rows output-table row-data))))))
	   output-table))))

(defun pack-securities-list-old (securities-list &key metric)
  "packs a frame of various securities for plotting purposes"
  (let* ((metric (or metric 'close))
         (output-frame (security-data (first securities-list))))
    (loop :for security :in (rest securities-list)
          :for series = (security-data security)
          :for metric-data = (lisp-stat:column series metric)
          :for ticker = (security-ticker security)
          :do (add-column! output-frame
                           (intern ticker)
                           metric-data))
    output-frame))

(defmacro with-securities-list
    ((date ticker name val hist securities-list &key value-metric max-days) &body body)
  "macro for iterating by day and security (nested) over a list of securities"
  (declare (type string date ticker name)
	   (type float val)
	   (type (list-of security) securities-list)
	   (type integer max-days)
	   (type symbol value-metric))
  (let ((sl (gensym "SECURITIES-LIST"))
        (sec (gensym "SECURITY"))
        (day (gensym "DAY"))
        (n-days (gensym "N-DAYS"))
        (hist-table (gensym "HIST-TABLE")))
    `(let* ((,sl ,securities-list)
            (,n-days (or ,max-days
                         (loop :for ,sec :in ,sl
                               :minimize (lisp-stat:nrow (security-data ,sec)))))
            (,hist-table (make-hash-table :test 'eq)))
       (dolist (,sec ,sl)
         (setf (gethash ,sec ,hist-table)
               (make-array ,n-days :fill-pointer 0 :adjustable t)))
       (loop :for ,day :below ,n-days
             :do (dolist (,sec ,sl)
                   (let* ((,ticker (security-ticker ,sec))
                          (,name   (security-name ,sec))
                          (,date   (lisp-stat:select (security-data ,sec) ,day 'date))
                          (,val    (lisp-stat:select (security-data ,sec) ,day ,value-metric))
                          (,hist   (gethash ,sec ,hist-table)))
                     (vector-push-extend ,val ,hist)
                     ,@body))))))

(in-package #:eigen)
(defsection @eigen-util (:title "Utility functions")
  "Various functions for application throughout Eigen."
  (list-of type)
  (random-sample-indices function)
  (date struct)
  (date->string function)
  (string->date function))

(deftype list-of (element-type)
  "Temporary stand-in for a list type."
  (declare (ignore element-type))
  'list)

(defun random-sample-indices (n max)
  "produces a list of n random indices within a range"
  (let ((all (loop :for i :from 0 :below max :collect i)))
    (subseq (alexandria:shuffle all) 0 (min n max))))

(defstruct date
  "Simple date structure for serializing and deserializing CSVs."
  (year  nil :type integer)
  (month nil :type integer)
  (day   nil :type integer))

(defun date->string (date)
  "Converts a date to a YYYY-MM-DD string."
  (declare (type date date))
  (format nil "~D-~D-~D"
	  (date-year date)
	  (date-month date)
	  (date-day date)))

(defun string->date (date-string)
  "Converts a YYYY-MM-DD string to date."
  (declare (type string date-string))
  (let ((tokens (mapcar #'parse-integer (cl-ppcre:split "-" date-string))))
    (make-date :year (first tokens)
	       :month (second tokens)
	       :day (third tokens))))

(defun stack-rows (df &rest objects)
  "Stack rows that works on matrices and/or data frames."
  (matrix-df
   (keys df)
   (apply #'aops:stack-rows (cons df objects))))

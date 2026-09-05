(in-package #:eigen)
(defsection @eigen-util (:title "Utility functions")
  "Various functions for application throughout Eigen."
  (list-of type)
  (random-sample-indices function)
  (date struct)
  (date->string function)
  (string->date function))

(deftype list-of (element-type)
  "Defines a compound type specifier for a list containing a specific type."
  (let ((predicate-name (gensym "LIST-OF-")))
    (setf (symbol-function predicate-name)
          #'(lambda (list-instance)
              (elements-are-of-type list-instance element-type)))
    `(and list (satisfies ,predicate-name))))

(defun random-sample-indices (n max)
  "produces a list of n random indices within a range"
  (let ((all (loop :for i :from 0 :below max :collect i)))
    (subseq (alexandria:shuffle all) 0 (min n max))))

(defstruct date
  "Simple date structure for serializing and deserializing CSVs."
  (year  :type integer)
  (month :type integer)
  (day   :type integer))

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

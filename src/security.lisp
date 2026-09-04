(in-package #:eigen)

;; general data struct containing the only data particularly necessary
(defstruct security ticker etf? name data-filepath data)

(defmacro with-securities-list ((date ticker name val hist securities-list &key value-metric max-days) &body body)
  "macro for iterating by day and security (nested) over a list of securities"
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

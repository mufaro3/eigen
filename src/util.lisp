(in-package #:eigen)

(defun random-sample-indices (n max)
  "produces a list of n random indices within a range"
  (let ((all (loop :for i :from 0 :below max :collect i)))
    (subseq (alexandria:shuffle all) 0 (min n max))))

(defun join-frame (securities-list &key metric)
  "joins a frame of various securities for plotting purposes"
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

(in-package #:eigen)

(defun plot-securities-list (sec-list))

(defun plot-security (sec &key (metric 'close) (start 0) end)
  "Plots a singular security (within a date index range) to a figure"
  (let* ((df-raw (security-data sec))
         (endv (or end (lisp-stat:nrow df-raw)))
         (dataframe (lisp-stat:select df-raw (lisp-stat:range start endv))))
    (plot:plot
     (vega:defplot price-vs-time
       `(:title ,(format nil "Closing Price of ~A vs. Time" (security-ticker sec))
	 :description ,(format nil "Price of ~A at Close vs. Time" (security-ticker sec))
	 :config (:renderer "svg")
	 :usermeta (:embed-options (:renderer "svg"))
	 :width 400
	 :height 400
	 :data (:values ,dataframe)
	 :mark :line
	 :encoding (:x (:field :date :type :temporal)
                    :y (:field ,metric :type :quantitative)))))))

(in-package #:eigen)
(defsection @eigen-plotting (:title "Plotting functions for Eigen")
  "Used for plotting time series to graphs."
  (plot-securities-list function)
  (plot-security function))

(defun plot-securities-list (sec-list &key (metric 'close) (start 0) end)
  "Plots a list of securities to a singular graph"
  (declare (type (list-of security) sec-list)
	   (type symbol metric)
	   (type integer start)
	   (type (or integer null) end))
  (let* ((df-raw (pack-securities-list sec-list :metric metric))
	 (endv (or end (lisp-stat:nrow df-raw)))
	 (dataframe (lisp-stat:select df-raw (lisp-stat:range start endv))))
    (plot:plot
     (vega:defplot price-vs-time-list
	 `(:title ,(format nil "~A Price vs. Time" (symbol-name metric))
	   :description ,(format nil "~A Price vs. Time" (symbol-name metric))
	   :config (:renderer "svg")
	   :usermeta (:embed-options (:renderer "svg"))
	   :width 400
	   :height 400
	   :data (:values ,dataframe)
	   :mark :line
	   :encoding (:x (:field :date :type :temporal)
                      :y (:field :value :type :quantitative)
		      :color (:field :ticker)))))))

(defun plot-security (sec &key (metric 'close) (start 0) end)
  "Plots a singular security (within a date index range) to a figure"
  (declare (type security sec)
	   (type symbol metric)
	   (type integer start)
	   (type (or integer null) end))
  (let* ((df-raw (security-data sec))
         (endv (or end (lisp-stat:nrow df-raw)))
         (dataframe (lisp-stat:select df-raw (lisp-stat:range start endv))))
    (plot:plot
     (vega:defplot price-vs-time-singular
	 `(:title ,(format nil "~A Price of ~A vs. Time"
			   (symbol-name metric)
			   (security-ticker sec))
	   :description ,(format nil "~A Price of ~A vs. Time"
				 (symbol-name metric)
				 (security-ticker sec))
	   :config (:renderer "svg")
	   :usermeta (:embed-options (:renderer "svg"))
	   :width 400
	   :height 400
	   :data (:values ,dataframe)
	   :mark :line
	   :encoding (:x (:field :date :type :temporal)
                      :y (:field ,metric :type :quantitative)))))))

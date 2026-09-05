;;;; eigen.asd

(asdf:defsystem #:eigen
  :description
  "Simple framework for financial analysis, \
including implementations of a few standard \
analysis algorithms"
  :author "Mufaro J. Machaya <mufaro2@student.ubc.ca>"
  :license  "MIT"
  :version "0.0.1"
  :serial t
  :depends-on (#:lisp-stat
	       #:plot/vega
	       #:alexandria
	       #:40ants-doc
	       #:cl-ppcre)
  :components ((:file "src/package")
               (:file "src/security")
	       (:file "src/portfolio")
	       (:file "src/util")
	       (:file "src/plotting")
	       (:file "src/example-data")))

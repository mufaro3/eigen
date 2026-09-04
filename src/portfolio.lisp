(in-package #:eigen)

;; types of market orders (BUY/SELL, symbol, quantity)
(defstruct market-order type symbol quantity)

;; naive buy/sell portfolio only
(defstruct portfolio-state cash-balance purchased-securities total-value orders)

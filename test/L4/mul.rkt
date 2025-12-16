#lang racket/base
(require "../../lang-model/L4.rkt")

(provide (all-defined-out))

;;simple mul
(define mul-0-in (arith * 2 3))
(define mul-0-out 6)

;;nested mul
(define mul-1-in (arith *
                        (arith * 2 3)
                        10))
(define mul-1-out 60)

(define mul-2-in (arith *
                        10
                        (arith * 2 3)))
(define mul-2-out 60)

;; nested mul
(define mul-3-in (arith *
                        (arith * 5 5)
                        (arith * 2 3)))
(define mul-3-out 150)
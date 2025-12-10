#lang racket/base
(require "../../lang-model/L1.rkt")

(provide (all-defined-out))

(define mix-0-in (arith +
                        (arith * 5 2)
                        (arith * 2 3)))
(define mix-0-out 16)

(define mix-1-in (arith +
                        (arith + 5 5)
                        (arith * 2 3)))
(define mix-1-out 16)

(define mix-2-in (arith *
                        (arith + 2 3)
                        (arith + 5 5)))

(define mix-2-out 50)

(define mix-3-in (arith *
                        (arith + 5 5)
                        (arith * 2 3)))
(define mix-3-out 60)


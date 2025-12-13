#lang racket/base
(require "../../lang-model/L3.rkt")

(provide (all-defined-out))

;;simple add
(define add-0-in (arith + 2 3))
(define add-0-out 5)

;;nested add
(define add-1-in (arith +
                        (arith + 2 3)
                        10))
(define add-1-out 15)

(define add-2-in (arith +
                        10
                        (arith + 2 3)))
(define add-2-out 15)

(define add-3-in (arith +
                        (arith + 5 5)
                        (arith + 2 3)))
(define add-3-out 15)
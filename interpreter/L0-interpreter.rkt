#lang racket
(require "../lang-model/L0.rkt")

;Expr->Integer
;interpret the expr as an integer
(define  (interpret expr)
  (match expr
    [(? integer?)  expr]
    [(arith op left right)
     (check-op op)
     (define value-left  (interpret left))
     (define value-right (interpret right))
     (op value-left value-right)]))

(define (check-op op)
  (when (not (or (equal? + op)  (equal? * op)))
    (error 'check-op " ~e not valid, must be  + or *" op)))

(module+ test
  (require "../test/L0/test-L0.rkt")
  (test-L0 interpret))

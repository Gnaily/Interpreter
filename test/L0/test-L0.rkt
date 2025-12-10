#lang racket/base
(require rackunit)
(require "./add.rkt")
(require "./mul.rkt")
(require "./mixed.rkt")

(provide (all-defined-out))

(define (test-L0 interpret)
  (check-equal? (interpret add-0-in) add-0-out)
  (check-equal? (interpret add-1-in) add-1-out)
  (check-equal? (interpret add-2-in) add-2-out)
  (check-equal? (interpret add-3-in) add-3-out)

  (check-equal? (interpret mul-0-in) mul-0-out)
  (check-equal? (interpret mul-1-in) mul-1-out)
  (check-equal? (interpret mul-2-in) mul-2-out)
  (check-equal? (interpret mul-3-in) mul-3-out)
  
  (check-equal? (interpret mix-0-in) mix-0-out)
  (check-equal? (interpret mix-1-in) mix-1-out)
  (check-equal? (interpret mix-2-in) mix-2-out)
  (check-equal? (interpret mix-3-in) mix-3-out))


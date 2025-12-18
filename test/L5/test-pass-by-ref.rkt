#lang racket/base
(require rackunit)
(require "./assign.rkt")
(provide (except-out (all-defined-out) assign-16-out))
(define assign-16-out 10)
(define (test-reference interpret)
  (check-equal? (interpret assign-16-in) assign-16-out))


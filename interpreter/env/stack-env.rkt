#lang racket/base

(provide

  #;(type Stack :[Vector Value]
         make-stack :: Number->Stack,
         push! :: Stack Value -> void,
         pop! :: Stack -> Value,
         lookup :: Stack Integer -> Value)
 make-stack push! pop! lookup)


(define TOP -1)
;represent top of the stack


(define (make-stack max-depth)
  (make-vector max-depth))


(define (pop! stack)
  (when (< TOP 0) (error "can't pop from an empty stack"))
  (let ([v (vector-ref stack TOP)])
    (set! TOP (sub1 TOP))
    v))

(define (push! stack value)
  (define top-limit (sub1 (vector-length stack)))
  (when (>= TOP top-limit) (error "stack overflow"))
  (set! TOP (add1 TOP))
  (vector-set! stack TOP value))

(define (lookup stack pos)
  (when (not
         (and
          (>= pos 0)
          (<= pos TOP)))
    (raise-argument-error 'lookup (format "must >=0 and <=~a " TOP) pos))
  (vector-ref stack (- TOP pos)))

(module+ test
  (require rackunit)
  (define s (make-stack 4))
  (push! s 1)
  (check-equal? TOP 0)
  (check-equal? (pop! s) 1)

  (push! s 1)
  (push! s 2)
  (push! s 3)
  (push! s 4)

  (check-equal? (lookup s  0) 4)
  (check-equal? (lookup s  3) 1)
  
  (check-equal? (pop! s) 4)
  (check-equal? (pop! s) 3)
  (check-equal? (pop! s) 2)
  (check-equal? (pop! s) 1))
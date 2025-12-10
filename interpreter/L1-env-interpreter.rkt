#lang racket
(require "../lang-model/L1.rkt")
(require "./env/list-env.rkt")


;Expr->Integer
;interpret the expr as an integer
(define (interpret expr)
  ;env is a accumulator
  (define (interpret/a expr env)
    (match expr
      [(? integer?) expr]
      [(arith op left right)
       (check-op op)
       (define value-left  (interpret/a left env))
       (define value-right (interpret/a right env))
       (op value-left value-right)]

      [(? string?)
       (check-variable expr env)
       (lookup expr env)]
      
      [(decl var expr body)
       (define value-expr (interpret/a expr env))
       (define env+ (add var value-expr env))
       (interpret/a body env+)]))
  (interpret/a expr empty))

(define (check-op op)
  (when (not (or (procedure? +) (procedure? *)))
    (error "op~e must be + or *" op)))

(define (check-variable var env)
  (when (not (defined? var env))
    (error 'interpret-expr "not defined varaible ~e" var)))


(module+ test
  (require "../test/L1/test-L1.rkt")
  (test-L1 interpret))

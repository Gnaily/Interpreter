#lang racket
(require "../lang-model/L2.rkt")
(require "./env/list-env.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     interpreter implementation -- Third Version 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (interpret-prog a-program)
  (match a-program
    [(program functions body) (interpret body functions)]))


(define (interpret expr functions)
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
       (interpret/a body env+)]
      
      [(call name arg)
       (check-function name functions)
       (define value-arg (interpret/a arg env))
       (define f (lookup-function name functions))
       (apply f value-arg empty)]))
  
  (define (apply function value-of-arg env)
    (define env+ (add (function-parameter function) value-of-arg env))
    (interpret/a (function-body function) env+))
  
  (interpret/a expr empty))



(define (defined-function? name functions)
  (ormap (lambda (f) (if (equal? (function-name f) name) f #f)) functions))

(define (lookup-function name functions)
  (defined-function? name functions))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;check;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (check-op op)
  (when (not (or (procedure? +) (procedure? *)))
    (error "op~e must be + or *" op)))

(define (check-variable var env)
  (when (not (defined? var env))
    (error 'interpret-expr "not defined varaible ~e" var)))

(define (check-function name functions)
  (when (not (defined-function? name functions))
    (error 'interpret-expr "not defined function ~e" name)))



(module+ test
  (require "../test/L2/test-L2.rkt")
  (define (interp p)
    (match p
      [(program functions body) (interpret-prog p)]
      [_ (interpret p empty)]))
  (test-L2 interp))
 

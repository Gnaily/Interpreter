#lang racket
(require "../lang-model/L4.rkt")
(require "./env/list-env.rkt")

(struct fun-value [parameter body env] #:transparent)
;(fun-value String Expr Env)
;represent function as value (aka closure)

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
       (check-variable expr env functions)
       (lookup-value expr env functions)]
      [(decl var expr body)
       (define value-expr (interpret/a expr env))
       (define env+ (add var value-expr env))
       (interpret/a body env+)]

      [(fun arg body) (fun-value arg body env)]
      [(call fn arg)
       (define value-arg (interpret/a arg env))
       (define value-fn (interpret/a fn env))
       (check-function value-fn)
       (apply value-fn value-arg)]

      [(if0 test then else)
       (define value (interpret/a test env))
       (if (and (number? value) (= value 0))
           (interpret/a then env)
           (interpret/a else env))]))
  
  (define (apply fvalue value-of-arg)
    (define env+ (add (fun-value-parameter fvalue) value-of-arg (fun-value-env fvalue)))
    (interpret/a (fun-value-body fvalue) env+))
  
  (interpret/a expr empty))


(define (lookup-value var env functions)
  (if (defined? var env)
      (lookup var env)
      (lookup-function var functions)))

(define (defined-function? name functions)
  (ormap (lambda (f) (if (equal? (function-name f) name) f #f)) functions))

(define (lookup-function name functions)
  (match (defined-function? name functions)
    [(function _ arg body) (fun-value arg body empty)]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;check;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (check-op op)
  (when (not (or (procedure? +) (procedure? *)))
    (error "op~e must be + or *" op)))

(define (check-variable var env functions)
  (when (not (defined? var env))
    (when (not (defined-function? var functions))
      (error 'check-variable "~e is not defined (neither variable or function)" var))))

(define (check-function fn)
  (when (not (fun-value? fn))
    (error 'check-function "~e is not a function" fn)))


(module+ test
  (require "../test/L4/test-L4.rkt")
  (define (interp p)
    (match p
      [(program _ _) (interpret-prog p)]
      [_ (interpret p empty)]))
  (test-L4 interp))
 

#lang racket
(require "../lang-model/L5.rkt")
(require "./env/list-env.rkt")
(require "./store/store.rkt")
(struct fun-value [parameter body env] #:transparent)
;(fun-value String Expr Env)
;represent function as value (aka closure)


(define (interpret-prog a-program)
  (match a-program
    [(program functions body) (interpret body functions)]))

(define (interpret expr functions)
  (define (interpret/a expr env store)
    (match expr
      [(? integer?) (values expr store)]
      [(arith op left right)
       (check-op op)
       (define-values (value-left store+) (interpret/a left env store))
       (define-values (value-right store++)(interpret/a right env store+))
       (values (op value-left value-right) store++)]

      [(? string?)
       (check-variable expr env functions)
       (define v (lookup-value expr env store functions))
       (values v store)]
      [(decl var expr body)
       (define-values (value-expr store+) (interpret/a expr env store))
       (define-values (loc store++) (alloc store+ value-expr))
       (define env+ (add var loc env))
       (interpret/a body env+ store++)]

      [(fun arg body) (values (fun-value arg body env) store)]
      [(call fn arg)
       (define-values (value-arg store+) (interpret/a arg env store))
       (define-values (value-fn store++) (interpret/a fn env store+))
       (check-function value-fn)
       (apply value-fn value-arg store++)]

      [(if0 test then else)
       (define-values (value store+)  (interpret/a test env store))
       (if (and (number? value) (= value 0))
           (interpret/a then env store+)
           (interpret/a else env store+))]

      [(set! var expr)
       (when (not (defined? var env))
         (error 'interpret "~e is not defined" var))
       (define loc (lookup var env))
       (define value (read-value store loc))
       (define-values (new-value store+) (interpret/a expr env store))
       (values value (update store+ loc new-value))]
      [(sequ first second)
       (define-values (_ store+)(interpret/a first env store))
       (interpret/a second env store+)]))
  
  (define (apply fvalue value-of-arg store)
    (define-values (loc store+) (alloc store value-of-arg))
    (define env+ (add (fun-value-parameter fvalue) loc
                      (fun-value-env fvalue)))
    (interpret/a (fun-value-body fvalue) env+ store+))
  (define-values (v s)
    (interpret/a expr empty empty-store))
  v)


(define (lookup-value var env store functions)
  (if (defined? var env)
      (read-value store (lookup var env))
      (lookup-function var functions)))

(define (defined-function? name functions)
  (ormap (lambda (f) (if (equal? (function-name f) name) f #f)) functions))

(define (lookup-function name functions)
  (match (defined-function? name functions)
    [(function _ arg body) (fun-value arg body empty)]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;check;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (check-op op)
  (when (not (or (procedure? +) (procedure? -) (procedure? *)))
    (error "op~e must be + or - or * " op)))

(define (check-variable var env functions)
  (when (not (defined? var env))
    (when (not (defined-function? var functions))
      (error 'check-variable "~e is not defined (neither variable nor function)" var))))

(define (check-function fn)
  (when (not (fun-value? fn))
    (error 'check-function "~e is not a function" fn)))

(module+ test
  (require "../test/L5/test-L5.rkt")
  (define (interp p)
    (match p
      [(program _ _) (interpret-prog p)]
      [_ (interpret p empty)]))
  (test-L5 interp))

#lang racket
(require "../lang-model/L3.rkt")
(require "./env/list-env.rkt")

(struct flat-closure [name free-vars] #:transparent)
(struct fetch-free-var (closure pos))
(struct function2 [name parameter closure body] #:transparent)


(define (interpret-prog a-program)
  (match a-program
    [(program functions body)
     
     (define funs
       (for/list ([f functions])
         (define-values (e fns) (closure-conv  (function-body f) (set-add  empty (function-parameter f) )))
         (append  fns (function2 (function-name f)  (function-parameter f) "_" e))))

     (define-values (e fns) (closure-conv body empty))
     
     (define all-functions
       (flatten (filter (lambda (e) (not (empty? e))) (append fns  funs))))
     
     (interpret e all-functions)]))

;; this interpreter interpret the closure converted program
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

      [(flat-closure name free-vars)
       (when (> (vector-length free-vars) 0)
         (allocate-value free-vars env))
       expr]
      [(fetch-free-var closure p)
       ;can think of that fetch-free-var is "compiled" to vector-ref
       (vector-ref (flat-closure-free-vars (interpret/a closure env)) p)]
               
      [(call fn arg)
       (define value-arg (interpret/a arg env))
       (define value-fn (interpret/a fn env))
       (apply value-fn value-arg)]))
  
  (define (allocate-value free-vars env)
    (for ([i (in-range (vector-length free-vars))])
      (vector-set! free-vars i (lookup (vector-ref free-vars i) env))))
  
  (define (apply fvalue value-of-arg)
    
    (match fvalue
      [(flat-closure name _ )
       (define f (lookup-function name functions))
       (define env+ (add (function2-parameter f) value-of-arg empty))
       
       (define env++ (add (function2-closure f)  fvalue env+))
       (interpret/a (function2-body f) env++)]
      [(function2 _ p _ b)
       (define env+ (add p value-of-arg empty))
       (interpret/a b env+)]))
  
  (interpret/a expr empty))

(define (lookup-value var env functions)
  (if (defined? var env)
      (lookup var env)
      (lookup-function var functions)))

(define (defined-function? name functions)
  (ormap (lambda (f) (if (equal? (function2-name f) name) f #f)) functions))

(define (lookup-function name functions)
  (defined-function? name functions))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;check;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (check-op op)
  (when (not (or (procedure? +) (procedure? *)))
    (error "op~e must be + or *" op)))

(define (check-variable var env functions)
  (when (not (defined? var env))
    (when (not (defined-function? var functions))
      (error 'check-variable "~e is not defined (neither variable or function)" var))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                    Closure conversion
;;1. track free-vars for locally defined function
;;2. do closure conversion for body of locally defined function
;;3. rewrite body of locally defined function and generate global
;;   function for it
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (closure-conv expr0 env0)
  ;env0:track bounded vars from expr0 to expr
  ;fns: track generated functions for closure
  (define (closure-conv/a expr env fns)
    (match expr
      [(? integer?) (values expr fns)]
      [(arith op left right)
       (define-values (l fns+)  (closure-conv/a left env fns))
       (define-values (r fns++)  (closure-conv/a right env fns+))
       (values (arith op l r) fns++)]

      [(? string?) (values expr fns)]
      
      [(decl var expr body)
       (define-values (e fns+) (closure-conv/a expr env fns))
       (define env+ (set-add env var))
       (define-values (b fns++) (closure-conv/a body env+ fns+))
       (values (decl var e b) fns++)]

      [(fun parameter body)
       (define-values (b fns+) (closure-conv/a body empty fns))
       (define-values (nbody vec) (rewrite-free-vars b env))
       (define fun-name (gensym 'fun_))
       (define closure (flat-closure fun-name vec))
       (define fns++ (cons (gen-function fun-name parameter "_cls_" nbody) fns+))
       (values closure fns++)]

      [(call fn arg)
       (define-values (a fns+)  (closure-conv/a arg env fns))
       (define-values (f fns++)  (closure-conv/a fn env fns+))
       (values (call f a) fns++)]))

  (define (gen-function name parameter closure body)
    (function2 name parameter closure body))
  
  (closure-conv/a expr0 env0 empty))


(define (rewrite-free-vars expr env)
  (define CLOSURE_PARAM_NAME "_cls_")
  (define (free-var? var)
    (set-member? env var))

  (define free-var-map (make-hash))

  (define (allocated-location? var)
    (hash-has-key? free-var-map var))

  (define (alloc-location var)
    (hash-set! free-var-map var (hash-count free-var-map)))

  (define (fetch-from-closure var)
    (define index (hash-ref free-var-map var))
    (fetch-free-var CLOSURE_PARAM_NAME index))

  (define (free-var-vector)
    (define free-var-vector (make-vector (hash-count free-var-map)))
    (for ([(k v) free-var-map])
      (vector-set! free-var-vector v k))
    free-var-vector)
  
  (define (rewrite-free-vars/a expr env)
    (match expr
      [(? integer?) expr]
      [(arith op left right)
       (define new-left  (rewrite-free-vars/a left env))
       (define new-right (rewrite-free-vars/a right env))
       (arith op new-left new-right)]

      [(? string?)
       (cond [(free-var? expr)
              (if (allocated-location? expr)
                  (fetch-from-closure expr)
                  (begin
                    (alloc-location expr)
                    (fetch-from-closure expr)))]
             [else expr])]
      
      [(decl var expr body)
       (define new-expr (rewrite-free-vars/a expr env))
       (define env+ (set-add var env))
       (decl var new-expr (rewrite-free-vars/a body env+))]

      [(flat-closure _ _) expr]

      [(call fn arg)
       (define new-fn (rewrite-free-vars/a fn env))
       (define new-arg (rewrite-free-vars/a arg env))
       (call new-fn new-arg)]))
  (values (rewrite-free-vars/a expr env) (free-var-vector)))

(module+ test
  (require "../test/L3/test-L3.rkt")
  (define (interp p)
    (match p
      [(program _ _) (interpret-prog p)]
      [_ (interpret p empty)]))
  (test-L3 interp))

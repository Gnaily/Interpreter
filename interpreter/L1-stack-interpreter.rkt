
#lang racket
(require "../lang-model/L1.rkt")
(require "./env/stack-env.rkt")
(provide
 (struct-out static)
 compile
 compile-alnative-way)

(struct static [distance] #:transparent)
;represent as a static distance from  which variable use to variable declare
;a Static is (Static Integer)

;Expr->Integer
;interpret the expr as an integer
(define (interpret expr)
  ;stack as accumlator(mutable&imperative),
  ;accumulate declared variable values from expr0 to expr
  (define stack (make-stack (max-deepth expr)))

  (define (interp expr)
    (match expr
      [(? integer?) expr]
      [(arith op left right)
       (define v-left (interp left))
       (define v-right (interp right))
       (op v-left v-right)]
      
      [(static distance) (lookup stack distance)]
      [(decl var expr body)
       (define v-expr (interp expr))
       (push! stack v-expr)
       (define value (interp body))
       (pop! stack)
       value]))
  (define cexpr (compile expr))
  (interp cexpr))

;;how deepth are the varariable declarations maximally nested
(define (max-deepth expr)
  (match expr
      [(? integer?) 1]
      [(arith op left right)
       (define d-left (max-deepth left))
       (define d-right (max-deepth right))
       (max  d-left d-right)]

      [(? string?) 1]
      [(decl var expr body)
       (define d-expr (max-deepth expr))
       (define d-body (add1 (max-deepth body)))
       (max d-expr d-body)]))



;Type: Expr->SdExpr
;complie an Expr to a static distance Expr.
;body of decl has no variable insted of the (static distance)
(define  (compile expr)
  (match expr
    [(? integer?)  expr]
    [(arith op left right)
     (check-op op)
     (define value-left  (compile left))
     (define value-right (compile right))
     (arith op value-left value-right)]
    
    [(? string?)  (error "undeclare variable ~e" expr)]
    [(static d) expr]
    [(decl var expr body)
     ;think carefully
     (define c-expr  (compile expr))
     (define s-body (subst var 0 body))
     (define c-body (compile s-body))
     (decl var c-expr c-body)] ))

;alnative way to compile
(define (compile-alnative-way expr)
  (match expr
    [(? integer?)  expr]
    [(arith op left right)
     (check-op op)
     (define value-left  (compile-alnative-way left))
     (define value-right (compile-alnative-way right))
     (arith op value-left value-right)]
    
    [(? string?)  expr]
    [(static d) expr]
    [(decl var expr body)
     (define c-expr  (compile-alnative-way expr))
     (define c-body (compile-alnative-way body))
     (define s-body (subst var 0 c-body))
     (decl var c-expr s-body)] ))

;Type: String Expr Number -> Expr
;repalce all var in body with (static distance)
(define (subst var d0 body)
  (match body
    [(? string?) (if (equal? var body) (static d0) body)]
    [(static d) body]
    [(? integer?) body]
    [(arith op left right)
     (let ([left  (subst var d0 left)]
           [right (subst var d0 right)])
       (arith op left right))]
    [(decl var-inner expr-inner body-inner)
     (define new-expr-inner (subst var (add1 d0) expr-inner))
     (if (equal? var var-inner)
         (decl var-inner new-expr-inner body-inner)
         (decl var-inner new-expr-inner (subst var (add1 d0) body-inner)))]))


(define (check-op op)
  (when (not (or (procedure? +) (procedure? *)))
    (error "op~e must be procedure + or *" op)))

(module+ test
  (require "../test/L1/test-L1.rkt")
  (test-L1 interpret))


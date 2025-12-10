#lang racket
(require "../lang-model/L1.rkt")


;Type: Expr->Integer
;given an expr, interpret it as an integer
(define  (interpret expr)
  (match expr
    [(? integer?)  expr]
    [(arith op left right)
     (check-op op)
     (define value-left  (interpret left))
     (define value-right (interpret right))
     (op value-left value-right)]
    [(? string?)  (error 'interpret "not declare variable -e" expr)]
    [(decl var expr body)
     (define new-expr (subst var expr body))
     (interpret new-expr)]) )

(define (check-op op)
  (when (not (or (equal? + op)  (equal? * op)))
    (error "op~e must be  + or *" op)))

;Type: String Expr Expr -> Expr
;repalce all var in body as expr
(define (subst var expr body)
  (match body
    [(? integer?) body]
    [(arith op left right)
     (let ([left  (subst var expr left)]
           [right (subst var expr right)])
       (arith op left right))]
    [(? string?) (if (equal? var body) expr body)]
    [(decl var-inner expr-inner body-inner)
     (define new-expr-inner (subst var expr expr-inner))
     (cond [(equal? var var-inner) (decl var-inner new-expr-inner body-inner)]
           [else
            (define new-body-inner
              (subst var expr
               (subst var-inner new-expr-inner body-inner)))
            (decl var-inner new-expr-inner new-body-inner)])]))

(module+ test
  (require "../test/L1/test-L1.rkt")
  (test-L1 interpret))
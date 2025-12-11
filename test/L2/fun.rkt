#lang racket/base
(require "../../lang-model/L2.rkt")
(provide (all-defined-out))

(define f1 (function "self" "x" "x"))

(define f2 (function "add1" "x" (arith + "x" 1)))

;;int and variable as argument
(define f3 (function "add2" "x" (arith + (call "self" 1) (call "add1" "x") )))

;arith as argument
(define f4 (function "mul2" "x" 
                     (call "self" (arith * "x" 2) )))

;declare as argument
(define f5 (function "mul3" "x" 
                     (call "self" 
                           (decl "x" (arith * "x" 3) "x"))))

;call as argument
(define f6 (function "add3" "x" 
                     (call "add1" (call "add2" "x"))))

;call in decl
(define f7 (function "add4" "x" 
                     (decl "add2" (call "add2" "x")
                           (decl "one" 1
                                 (call "add2" (arith * "one" "add2"))))))


(define functions (list f1 f2 f3 f4 f5 f6 f7))

(define (name f)
  (function-name f))

(define prog-1-in (program functions (call (name f1) 5))) 
(define prog-1-out 5) 

(define prog-2-in (program functions (call (name f2) 4))) 
(define prog-2-out 5) 

(define prog-3-in (program functions (call (name f3) 3))) 
(define prog-3-out 5) 

(define prog-4-in (program functions (call (name f4) 3))) 
(define prog-4-out 6)

(define prog-5-in (program functions (call (name f5) 3))) 
(define prog-5-out 9) 

(define prog-6-in (program functions (call (name f6) 3))) 
(define prog-6-out 6) 

(define prog-7-in (program functions (call (name f7) 3))) 
(define prog-7-out 7)



;(define (defined-function? name functions)
 ; (ormap (lambda (f) (if (equal? (function-name f) name) f #f)) functions))

;(defined-function? "add0" functions)
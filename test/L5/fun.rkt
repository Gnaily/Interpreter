#lang racket/base
(require "../../lang-model/L5.rkt")
(provide (except-out (all-defined-out) name))
(define (name f)
  (function-name f))

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
                     (decl "add-2" (call "add2" "x")
                           (decl "one" 1
                                 (call "add2" (arith * "one" "add-2"))))))
;variable point to function 
(define f8 (function "f8" "x" 
                     (decl "add" "add2"
                           (decl "one" 1
                                 (call "add" (arith * "one" "x"))))))
;function as parameter
(define f9 (function "f9" "x" 
                     (call "x" 3)))

;function as return               
(define f10 (function "f10" "x" 
                      "add2"))

;;variable point to local function
(define f11 (function "f11" "x" 
                      (decl "add"  (fun "x" (call "add2" "x"))
                            (decl "one" 1
                                  (call "add" (arith * "one" "x"))))))

(define f12 (function "f12" "x" 
                      (decl "add"  (fun "y" (call "add2" "x"))
                            (decl "one" 1
                                  (call "add" (arith * "one" "x"))))))

;;call local function  directly                               
(define f13 (function "f13" "x" 
                      (decl "one" 1
                            (call (fun "x" (arith * "one" (call "add2" "x"))) "x"))))

;;local function as parameter
(define f14 (function "f14" "x" 
                      (call (call "self" (fun "y" (arith + "y" "x"))) 2)))

;;local function as return
(define f15 (function "f15" "x" 
                      (fun "y" (arith + "y" "x"))))

(define functions (list f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15))

(define function-1-in (program functions (call (name f1) 5))) 
(define function-1-out 5) 

(define function-2-in (program functions (call (name f2) 4))) 
(define function-2-out 5) 

(define function-3-in (program functions (call (name f3) 3))) 
(define function-3-out 5) 

(define function-4-in (program functions (call (name f4) 3))) 
(define function-4-out 6)

(define function-5-in (program functions (call (name f5) 3))) 
(define function-5-out 9) 

(define function-6-in (program functions (call (name f6) 3))) 
(define function-6-out 6) 

(define function-7-in (program functions (call (name f7) 3))) 
(define function-7-out 7)

(define function-8-in (program functions (call (name f8) 3))) 
(define function-8-out 5)

(define function-9-in (program functions (call (name f9) "add2"))) 
(define function-9-out 5)

(define function-10-in (program functions (call (call (name f10)  100) 3))) 
(define function-10-out 5)

(define function-11-in (program functions (call (name f11)  3))) 
(define function-11-out 5)

(define function-12-in (program functions (call (name f12)  3))) 
(define function-12-out 5)

(define function-13-in (program functions (call (name f13)  3))) 
(define function-13-out 5)

(define function-14-in (program functions (call (name f14)  3))) 
(define function-14-out 5)

(define function-15-in (program functions (call (call (name f15)  3) 2))) 
(define function-15-out 5)
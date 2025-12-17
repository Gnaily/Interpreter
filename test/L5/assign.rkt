#lang racket/base
(require "../../lang-model/L5.rkt")
(provide (all-defined-out))

;set x to arith
(define assign-1-in (decl "x" 1
                          (set! "x" 2)))
(define assign-1-out 1)      

(define assign-2-in (decl "x" 1
                          (sequ 
                           (set! "x" 2)
                           "x")))
(define assign-2-out 2) 


(define assign-3-in (decl "x" 1
                          (sequ (set! "x" (arith + 2 "x"))
                                (arith + "x" "x"))))
(define assign-3-out 6)   

(define assign-4-in 
  (decl "x" 1
        (sequ (set! "x" (decl "y" "x"
                              (set! "x" (arith * 2 "y")))     )
              (arith + "x" "x"))))
(define assign-4-out 2) 

;set x to decl
(define assign-5-in 
  (decl "x" 1
        (sequ (set! "x" (decl "y" "x"
                              (sequ 
                               (set! "x" (arith * 2 "y"))
                               "x")))
              (arith + "x" "x"))))
(define assign-5-out 4) 

;set x to fun
(define assign-6-in 
  (decl "x" 1
        (sequ (set! "x" (fun "y" (arith + 1 "y")))
              (call "x" 1))))
(define assign-6-out 2) 

(define assign-7-in 
  (decl "x" 1
        (sequ (set! "x" (fun "y" 
                             (if0 "y" 100 
                                  (call "x" (arith - "y" 1)))))
              (call "x" 1))))
(define assign-7-out 100) 

;set x to call
(define assign-8-in 
  (decl "x" 1
        (sequ 
         (set! "x" (call (fun "x" (arith + "x" 1)) "x"))
         (call (fun "x" (arith + "x" 1)) "x"))))
(define assign-8-out 3) 

(define assign-9-in 
  (decl "x" 1
        (sequ 
         (set! "x" (call (fun "x" (arith + "x" 1)) "x"))
         (call (fun "y" (arith + "x" 1)) 0))))
(define assign-9-out 3) 

;set x to if
(define assign-10-in 
  (decl "x" 1
        (sequ (set! "x" (if0 "x" 1 0))
              "x")))
(define assign-10-out 0) 

;set in arith
(define assign-11-in 
  (decl "x" 1
        (arith + (set! "x" 2)
               "x")))
(define assign-11-out 3) 

(define assign-12-in 
  (decl "x" 1
        (arith + (sequ (set! "x" 2) "x")
               "x")))
(define assign-12-out 4) 

;set in if
(define assign-13-in 
  (decl "x" 1
        (if0 (sequ (set! "x" 0) "x")  (sequ (set! "x" 2) "x") 
             (sequ (set! "x" 3) "x") )))
(define assign-13-out 2) 

(define assign-14-in 
  (decl "x" 1
        (if0  (set! "x" 0)  (sequ (set! "x" 2) "x") 
              "x")))
(define assign-14-out 0)

;set in fun
(define assign-15-in 
  (decl "x" 1
        (call (fun "x" (sequ (set! "x" 10) "x")) "x")))
(define assign-15-out 10) 

(define assign-16-in 
  (decl "x" 1
        (sequ
         (call (fun "x" (sequ (set! "x" 10) "x")) "x")
         "x")))
(define assign-16-out 1) 
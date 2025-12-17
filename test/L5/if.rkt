#lang racket/base
(require "../../lang-model/L5.rkt")
(provide (except-out (all-defined-out) name))

(define (name f)
  (function-name f))

;simple if
(define if-0-in (if0 0 1 2))
(define if-0-out 1)

(define if-1-in (if0 1 1 2))
(define if-1-out 2)

;nested if
(define if-2-in (if0 0 (if0 0 1 2) 3))
(define if-2-out 1)

(define if-3-in (if0 0 (if0 10 1 2) 3))
(define if-3-out 2)

(define if-4-in (if0 5 (if0 0 1 2) (if0 0 3 4)))
(define if-4-out 3)

(define if-5-in (if0 (if 0 1 0) (if0 0  1 2) (if0 0 3 4)))
(define if-5-out 3)

(define if-6-in (if0 (if0 1 1 0) (if0 0 1 2) (if0 0 3 4)))
(define if-6-out 1)

;if in arith
(define if-7-in (arith + (if0 1 2 3) (if0 0 1 0)))
(define if-7-out 4)

;arith in if 
(define if-8-in  (if0 (arith + 0 1) (arith + 2 3) (arith * 2 3)))
(define if-8-out 6)

;if in decl
(define if-9-in (decl "v" (if0 0 1 2)
                      (if0 "v" 3 4)))
(define if-9-out 4)

(define if-10-in (decl "v0" (if0 0 1 2)
                       (decl "v1" (if0 1 3 4)
                             (if "v0" "v1" "v0"))))
(define if-10-out 4)

;decl in if
(define if-11-in  (if0 (decl "v0" 1 "v0")
                       (decl "v1" 2 "v1")
                       (decl "v1" 3 "v1")))
(define if-11-out 3)

;if in function
(define sub1 (function "sub1" "x" (arith - "x" 1)))
(define rec0 (function "rec" "x" 
                       (if0 "x" 0
                            (call "rec" (call "sub1" "x")))))

(define if-12-in (program (list sub1 rec0) (call (name rec0) 4))) 
(define if-12-out 0)

(define rec1 (function "rec" "x" 
                       (if0 (call (fun "x" (call "sub1" "x")) "x") 0
                            (call "rec" (call "sub1" "x")))))

(define if-13-in (program (list sub1 rec1) (call (name rec1) 4))) 
(define if-13-out 0)


(define rec2 (function "rec" "x" 
                       (if0 (call  "sub1" "x") 0
                            (call "rec" (if0 "x" 1 (call  "sub1" "x"))))))

(define if-14-in (program (list sub1 rec2) (call (name rec2) 4))) 
(define if-14-out 0)

(define f (function "f" "x" 
                    (if0 "x" (arith + "x" 1)
                         (call (if0 (call "sub1" "x") 
                                    "sub1" 
                                    (fun "x" (arith + "x" 1))) "x") )))

(define if-15-in (program (list sub1 f) (call (name f) 0))) 
(define if-15-out 1)

(define if-16-in (program (list sub1 f) (call (name f) 1))) 
(define if-16-out 0)

(define if-17-in (program (list sub1 f) (call (name f) 2))) 
(define if-17-out 3)
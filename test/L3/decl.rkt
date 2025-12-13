#lang racket/base
(require "../../lang-model/L3.rkt")

(provide (all-defined-out))


(define decl-1-in (decl "x" 1 10))

;;body is var
(define decl-2-in (decl "x" 10 "x"))

;;var right is arith
(define decl-3-in (decl "x" (arith + 2 8) "x"))

;;body is arith
(define decl-4-in (decl "x" 2
                        (arith + "x" 8)))

(define decl-5-in (decl "x" 2
                        (arith *
                               "x"
                               (arith + "x" 3))))
;;var right is declare
(define decl-6-in (decl "x"
                        (decl "x" 3
                              (arith + 2 "x"))
                        (arith * "x" 2)))
;;body is declare
(define decl-7-in (decl "x" 2
                        (decl "x" 5
                              (arith * "x" 2))))
;;declare in arith
(define decl-8-in (arith * 2 (decl "y" 3
                                   (arith + 2 "y"))))

;;nested declare
(define decl-9-in (decl "x" 2
                        (arith * "x"
                               (decl "y" 1
                                     (decl "z" 3
                                           (arith * "y"
                                                  (arith + "z" "x")))))))
(define decl-out 10)
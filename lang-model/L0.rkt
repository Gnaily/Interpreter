#lang racket
(provide (all-defined-out))

#;(L0(Lauguage0)
   ----------------------------------------------------
   ;Feature
   - simple arith
   ----------------------------------------------------
   ;Grammar
   expr := Int | (node + expr expr) | (node * expr expr)
   program := expr)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                     represent grammer as ast
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(struct arith [op left right] #:transparent)
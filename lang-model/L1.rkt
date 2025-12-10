#lang racket
(provide (all-defined-out))

#;(L1 Language
   ----------------------------------------------------
   ;Feature
   - simple arith
   - variable and scope
   ----------------------------------------------------
   ;Grammar
   expr := Int | (node + expr expr) | (node * expr expr)
   | variable | (decl variable expr expr)
   program := expr
   variable:= string)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                     represent grammer as ast
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(struct arith [op left right] #:transparent)
(struct decl [var expr body] #:transparent)
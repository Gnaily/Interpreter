#lang racket/base
(provide (all-defined-out))

#;(L1 Language
   ----------------------------------------------------
   ;Feature
   - simple arith
   - variable and scope
   - global function
   ----------------------------------------------------
   ;Grammar
   expr := Int | (node + expr expr) | (node * expr expr)
   | variable | (decl variable expr expr)
   | (call variable expr)|
   
   function := (fun variable variable expr)
   program := [[Listof function] expr]
   variable:= string)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                     represent grammer as ast
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(struct arith [op left right] #:transparent)
(struct decl [var expr body] #:transparent)
(struct function [name parameter body] #:transparent)
(struct call [name argument] #:transparent)
(struct program [functions body]  #:transparent)
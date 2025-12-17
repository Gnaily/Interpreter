#lang racket/base
(provide (all-defined-out))

#|L5 Language
   ----------------------------------------------------
   ;Feature
   - simple arith
   - variable and scope
   - global function
   - local function
   - condition
   - assignment
   ----------------------------------------------------
   
   ;Grammar
   ----------------------------------------------------
   expr := Int | (node + expr expr) | (node * expr expr)
   | variable | (decl variable expr expr)
   | (call expr expr)|(fun variable expr)
   | (if0 expr expr expr)
   | (set! variable expr)
   | (sequ expr expr)
   function := (function variable variable expr)
   program := [[Listof function] expr]
   variable:= string
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                     represent grammer as ast
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(struct arith [op left right] #:transparent)
(struct decl [var expr body] #:transparent)
(struct function [name parameter body] #:transparent)
(struct call [fun argument] #:transparent)
(struct fun [parameter body] #:transparent)
(struct program [functions body]  #:transparent)
(struct if0 [test then else]  #:transparent)
(struct set! [var rhs]  #:transparent)
(struct sequ [left right]  #:transparent)
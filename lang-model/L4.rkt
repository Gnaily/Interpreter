#lang racket/base
(provide (all-defined-out))

#|L4 Language
   ----------------------------------------------------
   ;Feature
   - simple arith
   - variable and scope
   - global function
   - local function
   ----------------------------------------------------
   
   ;Grammar
   ----------------------------------------------------
   expr := Int | (node + expr expr) | (node * expr expr)
   | variable | (decl variable expr expr)
   | (call expr expr)|(fun variable expr)
   | (if0 expr expr expr)
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
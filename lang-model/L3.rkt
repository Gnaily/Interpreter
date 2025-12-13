#lang racket/base
(provide (all-defined-out))

#;(L3 Language
   ----------------------------------------------------
   ;Feature
   - simple arith
   - variable and scope
   - global function
   - local function
   ----------------------------------------------------
   ;Grammar
   expr := Int | (node + expr expr) | (node * expr expr)
   | variable | (decl variable expr expr)
   | (call expr expr)|(lambda variable expr)
   
   function := (function variable variable expr)
   program := [[Listof function] expr]
   variable:= string)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                     represent grammer as ast
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(struct arith [op left right] #:transparent)
(struct decl [var expr body] #:transparent)
(struct function [name parameter body] #:transparent)
(struct call [fun argument] #:transparent)
(struct fun [parameter body] #:transparent)
(struct program [functions body]  #:transparent)
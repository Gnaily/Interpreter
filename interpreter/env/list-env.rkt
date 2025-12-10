#lang racket/base
(require racket/list)

(provide
 #;(type Env :[List [List Var Value]]
         empty :: Env,
         add :: Var Value Env -> Env,
         defined? :: Var Env -> [List Var Value] || Boolean,
         lookup :: Var Env -> Value)
   
 empty defined? add lookup)
   
(define empty '[])
(define (add key value env) (cons (list key value) env))
(define (defined? key env) (assoc key env))
(define (lookup key env) (second (defined? key env)))
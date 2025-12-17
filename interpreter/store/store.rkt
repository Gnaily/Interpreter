#lang racket/base
(require racket/list)

(provide
 #;(type Store :[List [List Location Value]]
         alloc :: Store Value->Location Store
         read-value :: Store Location -> Value
         update ::  Store Location Value-> Store
         )
 empty-store alloc read-value update)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;         Store, the functional implementation
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define empty-store '[])

(define (alloc store value)
  (define used-max-loc (foldl max 0 (map first store)))
  (define new-loc (add1 used-max-loc))
  (values new-loc (cons (list new-loc value) store)))

(define (read-value store location)
  (define finded (assoc location store))
  (if finded (second finded) (error "location of ~e is not exist" location)))

(define (update store location value)
  (cons (list location value) store))

(module+ test
  (require rackunit)

  (define-values (loc1 store1) (alloc empty "a"))
  (check-equal? loc1 1)
  (check-equal? (read store1 loc1) "a")
  
  (define-values (loc2 store2) (alloc store1 "b"))
  (check-equal? loc2 2)
  (check-equal? (read store2 loc1) "a")
  (check-equal? (read store2 loc2) "b")
  (check-equal? (read (update store2 loc2 "c") loc2) "c"))
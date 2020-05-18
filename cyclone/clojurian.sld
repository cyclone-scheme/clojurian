(define-library (cyclone clojurian)
  (import (scheme base))
  (export doto 
          as->
          and->
          ->
          ->*
          ->>
          ->>*
          if-let
          if-let*)
  (begin
    ;; originally contributed by Martin DeMello
    ;; rewritten in terms of syntax-rules by Moritz Heidkamp
    (define-syntax doto
      (syntax-rules ()
        ((_ x) x)
        ((_ x (fn args ...) ...)
         (let ((val x))
           (fn val args ...)
           ...
           val))))

    (define-syntax as->
      (syntax-rules ()
        ((_ state name) state)
        ((_ state name expr)
         (let ((name state))
           expr))
        ((_ state name expr rest ...)
         (as-> (let ((name state))
                 expr) name rest ...))))

    (define-syntax and->
      (syntax-rules ()
        ((_ x) x)
        ((_ x (y args ...) z ...)
         (and-let* ((x* x))
           (and-> (y x* args ...) z ...)))
        ((_ x y z ...)
         (and-> x (y) z ...))))

    (define-syntax ->
      (syntax-rules ()
        ((_ x) x)
        ((_ x (y z ...) rest ...)
         (-> (y x z ...) rest ...))
        ((_ x y rest ...)
         (-> x (y) rest ...))))

    (define-syntax ->>
      (syntax-rules ()
        ((_ x) x)
        ((_ x (y ...) rest ...)
         (->> (y ... x) rest ...))
        ((_ x y rest ...)
         (->> x (y) rest ...))))

    (define-syntax ->*
      (syntax-rules ()
        ((_ x) x)
        ((_ x (y z ...) rest ...)
         (->* (receive args x
                (apply y (append args (list z ...))))
              rest ...))
        ((_ x y rest ...)
         (->* x (y) rest ...))))

    (define-syntax ->>*
      (syntax-rules ()
        ((_ x) x)
        ((_ x (y z ...) rest ...)
         (->>* (receive args x
                 (apply y (append (list z ...) args)))
               rest ...))
        ((_ x y rest ...)
         (->>* x (y) rest ...))))

    (define-syntax if-let
      (syntax-rules ()
        ((_ (x y) then else)
         (let ((x y))
           (if x then else)))))

    (define-syntax if-let*
      (syntax-rules ()
        ((_ ((x y) more ...) then else)
         (car (or (and-let* ((x y) more ...)
                    (list then))
                  (list else))))))))

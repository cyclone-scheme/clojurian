(import (scheme base)
        (scheme inexact)
        (srfi 1)
        (cyclone test)
        (cyclone clojurian))

;; Original tests by Moritz Heidkamp on
;; https://bitbucket.org/DerGuteMoritz/clojurian/src/master/tests/syntax.scm

(define add1 (lambda (x) (+ 1 x)))

(test-group "clojurian-syntax"
  (test (vector 1 2)
        (doto (make-vector 2)
              (vector-set! 0 1)
              (vector-set! 1 2)))

  (test 'foo (doto 'foo)))

(test-group ""
  (test 1.0 (-> 99 (/ 11) (/ 9)))

  (test '(1 2 3 4)
        (->* (values 1 2)
             (list 3)
             (append '(4))))

  (test 3 (as-> 3 x))
  (test 2.0 (as-> 1 x (+ x 3) (/ x 2)))
  (test 5.0 (-> 10 (* 2) (as-> state (/ state 4))))

  (test 7 (-> 10 (- 3)))
  (test -7 (->> 10 (- 3)))

  (test 9 (->> 1 (+ 2) (* 3)))

  (test -1 (-> 1 -))
  (test 2.0 (-> 14 (+ 2) sqrt (- 2)))
  (test '(1 2) (->* (values 1 2) list))

  (test 9 (->> '(1 2 3)
               (map add1)
               (fold + 0)))

  (test -1 (->> 1 -))

  (test '((foo . 100) (bar . 200))
        (->>* (values '(foo bar) '(100 200))
              (map cons)))

  (test '("a" "b")
        (->>* (values 'a 'b)
              list
              (map symbol->string)))

  (test 9 (and-> 1 (+ 2) (* 3)))
  (test -1 (and-> 1 -))
  (test #f (and-> #f not))
  (test 2 (and-> (assq 'x '((x . 1))) cdr add1))
  (test #f (and-> (assq 'x '((y . 1))) cdr add1)))

(test-group "if-let & if-let*"
  (test 2 (if-let (x 1) (+ x x) 9))
  (test 9 (if-let (x #f) (+ x x) 9))

  (test (list 3 6)
        (if-let* ((foo 3) (bar (* foo 2)))
                 (list foo bar)
                 'wrong))

  (test 'wrong
        (if-let* ((foo #f) (bar (* foo 2)))
                 (list foo bar)
                 'wrong))

  (test #f (if-let (x #t) #f 'wrong))
  (test #f (if-let* ((x #t)) #f 'wrong)))


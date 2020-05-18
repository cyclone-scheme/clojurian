# clojurian
## Index 
- [Intro](#Intro)
- [Dependencies](#Dependencies)
- [Test dependencies](#Test-dependencies)
- [Foreign dependencies](#Foreign-dependencies)
- [API](#API)
- [Examples](#Examples)
- [Author(s)](#Author(s))
- [Maintainer(s)](#Maintainer(s))
- [Version](#Version) 
- [License](#License) 
- [Tags](#Tags) 

## Intro 
A collection of modules providing syntax and utility functions inspired by [Clojure](https://clojure.com).

## Dependencies 
None

## Test-dependencies 
None

## Foreign-dependencies 
None

## API 

### (cyclone clojurian)

#### `(doto val (proc args ...) ...)` 

Inserts val as the first argument of each (proc args ...) clause (i.e. right after proc). Returns val. This is useful e.g. for mutating a record on initialization.

Example:
```scheme
(define boolean-vector
  (doto (make-vector 100)
        (vector-fill! #t 0 50)
        (vector-fill! #f 50)))
=>

(define boolean-vector
  (let ((vec (make-vector 100)))
    (vector-fill! vec #t 0 50)
    (vector-fill! vec #f 50)
    vec))
```

#### `(-> val (proc args ...) ...)`

Inserts val as the first argument of the first (proc args ...) clause. The resulting form is then inserted as the first argument of the following proc form and so on. This is known as the thrush combinator. 

Single value example:
```scheme
(-> 10 (- 2) (/ 5) (* 3))

=>

(* (/ (- 10 2) 5) 3)
```

#### `(->* val (proc args ...) ...)`

The starred version (->*) is multi value aware, i.e. each form's return values are spliced into the argument list of the successing form. As a shorthand it is also possible to pass proc instead of (proc).

Multi value example:

```scheme
(->* (values 1 2) (list))

=>

(receive args (values 1 2) (apply list args))
```

#### `(->> val (proc args ...) ...)` and `(->>* val (proc args ...) ...)`

Works just like -> and ->* only that the forms are inserted at the end of each successive clause's argument list.

Example:
```scheme
(->> (iota 10)
     (map add1)
     (fold + 0)
     (print))

=>

(print
 (fold + 0
  (map add1
   (iota 10))))
```

#### `(as-> val name forms ...)`

Evaluates forms in order in a scope where name is bound to val for the first form, the result of that for the second form, the result of that for the third form, and so forth. Returns the result of the last form.

Examples:
```scheme
(as-> 3 x (+ x 7) (/ x 2)) => 5
```
It's mainly useful in combination with ->:
```scheme
(-> 10 (+ 3) (+ 7) (as-> x (/ 200 x))) => 10
```

#### `(and-> val forms ...)`

Works just like -> but will return #f in case val or any of the forms evaluates to #f.

Examples:
```scheme
(define some-alist '((a . 1) (b . 2)))

(and-> 'b (assq some-alist) cdr add1) => 3

(and-> 'c (assq some-alist) cdr add1) => #f
```

This syntax is essentially a shortcut for certain uses of and-let*, e.g. the above example would often be expressed like this:

```scheme
(and-let* ((x 'b)
           (x (assq x some-alist))
           (x (cdr x)))
  (add1 x))
```

#### `(if-let (var val) then else)`

Equivalent to `(let ((var val)) (if var then else))`.

#### `(if-let* ((x1 y1) (x2 y2) ...) then else)` 

Similar to `(or (and-let* ((x1 y1) (x2 y2) ...) then) else)` except that returning #f from the then clause will not lead to the else clause being evaluated.

*Attention*: the original Clojurian egg for CHICKEN Scheme provides `atom` and other definitions wich are implemented in Cyclone by the `(cyclone concurrent)` library (see [here](http://justinethier.github.io/cyclone/docs/api/cyclone/concurrent)).

## Author(s)
[Moritz Heidkamp](http://wiki.call-cc.org/users/moritz-heidkamp)

## Maintainer(s) 
Arthur Maciel <arthurmaciel at gmail dot com>

## Version 
0.1

## License 
BSD

Copyright (c) 2014-2018, Moritz Heidkamp
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

Neither the name of the author nor the names of its contributors may
be used to endorse or promote products derived from this software
without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.

## Tags 
"lang extensions"

#lang racket/base

(require unreal
         (prefix-in unreal: vr-cabin/lang)
         racket/generator
         racket/format
         racket/match
         racket/list)

(provide 
 generator
 
 with-spawn
 (rename-out [my-#%app #%app])
 #%top
 #%module-begin
 #%top-interaction
 #%datum

 force
 force-to
 anchor
 random
 color
 (rename-out [unreal:red red]
             [unreal:blue blue]
             [unreal:orange orange]
             [unreal:green green])
 

 let
 define
 lambda
 if
 cond
 when
 match
 
 eq?
 >=
 <=
 =
 <
 >
 +
 -
 *
 /
 positive?
 negative?
 list
 shuffle
 length
 first
 last
 rest
 list-ref
 min
 max
 )

(define white-list
  (list random
        eq?
        >=
        <=
        =
        <
        >
        +
        -
        *
        /
        positive?
        negative?
        list
        shuffle
        length
        first
        last
        rest
        list-ref
        min
        max))


(define spawn (make-parameter #f))
(define-syntax-rule (with-spawn m lines ...)
  ;Prolly needs to be securified too...
  (parameterize ([spawn m])
    lines ...))


(define-syntax-rule (my-#%app f args ...)
  (let ()
    (displayln (~a "    Calling " 'f))
    (when (not (member f white-list))
      ;Special things can be free.
      ;But what if user redefines things like (random)?
      (displayln (~a "    Yielding " 'f))
      (yield 'f))
    (#%app f args ...)))

(define (force x y z)
  (unreal-eval-js ;Do something fancy with #%top?
   (unreal:force (spawn) x y z)))

(define (force-to name mag)
  (unreal-eval-js
   (unreal:force-to (spawn) name mag)))

(define (anchor name)
  (unreal-eval-js
   (unreal:anchor (spawn) name)))

(define (color col)
  (unreal-eval-js 
   (unreal:color (spawn) col)))
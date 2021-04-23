#lang racket/base

(provide 
 generator
 
 with-mini
 (rename-out [my-#%app #%app])
 #%top
 #%module-begin
 #%top-interaction
 #%datum

 let
 force
 random
 color

 ;define

 )

(require unreal
         (prefix-in unreal: vr-cabin/lang)
         racket/generator
         racket/format

         vr-cabin/chat)


(define mini (make-parameter #f))
(define-syntax-rule (with-mini m lines ...)
  ;Prolly needs to be securified too...
  (parameterize ([mini m])
    lines ...))

(define-syntax-rule (my-#%app f args ...)
  (let ()
    (displayln (~a "    Calling " 'f))
    (when (not (eq? 'f 'random))
      ;Special things can be free.
      ;But what if user redefines things like (random)?
      (displayln (~a "    Yielding " 'f))
      (yield 'f))
    (#%app f args ...)))

(define (force x y z)
  (unreal-eval-js ;Do something fancy with #%top?
   (unreal:force (mini) x y z)))

(define (color col)
  (unreal-eval-js 
   (unreal:color (mini) col)))
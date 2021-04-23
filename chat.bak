#lang at-exp racket

(require unreal
         (prefix-in unreal: fish-tank/lang))

(provide #%module-begin
         #%top-interaction
         #%app
         #%datum
         with-twitch-id

         help
         topic
         fish
         color
         red
         green)

(define current-twitch-id (make-parameter #f))

(define-syntax-rule (with-twitch-id id lines ...)
  (parameterize ([current-twitch-id id])
    lines ...))

(define (color) color) ;No real meaning yet.  Just makes help work
(define (topic) topic) ;No real meaning yet.  Just makes help work

(define (help . args)
  (cond
    [(empty? args)
     @~a{OhMyDog  Use "!!help [topic]" to get more info.  Available topics: fish, help}]
    [(equal? (list help) args)
     @~a{OhMyDog Help is a command you use to learn the language I understand.  Try "!!help fish"}]
    [(equal? (list fish) args)
     @~a{OhMyDog Help with fish?  Sure!
      Use "!!fish" or "!!fish [color]" to add a fish
      to the tank.  Or type "!!help fish color"
      for more info}]
    [(equal? (list topic) args)
     @~a{OhMyDog Umm, no.  Don't type "!!help topic", type "!!help [topic]".
      Available topics: fish, help.  Examples: "!!help fish" "!!help help")}]
    [(equal? (list color) args) ;Not an available topic, but still maybe useful.
     @~a{OhMyDog Available colors: red, green.  "}]
    [(equal? (list fish color) args)
     @~a{OhMyDog Try "!!fish [color]".  Available colors: red, green.}]
    
 )

  )

(define red "red")
(define green "green")

(define (fish [color red])
  (define spawned
    (unreal-eval-js (unreal:fish color)))

  @~a{You spawned a @color fish!"})



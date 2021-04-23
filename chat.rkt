#lang at-exp racket

(require unreal
         (prefix-in unreal: vr-cabin/lang)
         racket/generator)

(provide #%module-begin
         #%top-interaction
         #%app
         #%datum
         with-twitch-id

         

         help
         topic
         mini
         force
         show-spell
         run)

(define (between? num1 num2)
  (lambda (x)
    (and (number? x) (<= num1 x) (>= num2 x))))

(define current-twitch-id (make-parameter #f))

(define-syntax-rule (with-twitch-id id lines ...)
  ;TODO: Fail if current twitch id already set.
  ;  Security bug
  (parameterize ([current-twitch-id id])
    lines ...))

(define (topic) topic) ;No real meaning yet.  Just makes help work

(define (help . args)
  (cond
    [(empty? args)
     @~a{OhMyDog  Use "!!help [topic]" to get more info.  Available topics: mini, help}]
    [(equal? (list help) args)
     @~a{OhMyDog Help is a command you use to learn the language I understand.  Try "!!help mini"}]
    [(equal? (list mini) args)
     @~a{OhMyDog Mini is a command you use to spawn your mini into the world.  Try "!!mini"}]
    [(equal? (list force) args)
     @~a{OhMyDog Force is a command you use to apply a.  Try "!!mini"}]
 ))

(define current-minis (hash))
(define current-programs (hash))

(define runner #f)

(define (mini)
  (if (hash-has-key? current-minis (current-twitch-id))
      @~a{You already have a mini!"}
      (let ()
        (define spawned
          (unreal-eval-js (unreal:mini (current-twitch-id))))

        (set! current-minis (hash-set current-minis (current-twitch-id) spawned))

        @~a{You spawned a mini!"})))

(define/contract (force x y z)
  (-> (between? -10000 10000)
      (between? -10000 10000)
      (between? -10000 10000)
      string?)

  (if (not (hash-has-key? current-minis (current-twitch-id)))
      @~a{You don't have a mini yet!"}
      (let ()
        (unreal-eval-js
         (unreal:force (hash-ref current-minis (current-twitch-id))
                       x y z))
        @~a{May the force be with you...})))

(define safe-ns #f)
(dynamic-require 'vr-cabin/run-lang #f)
(define (setup-ns)
  (displayln "Starting def...")
  (when (not safe-ns)
    (set! safe-ns
          (parameterize ([current-namespace
                          (make-base-empty-namespace)])
            (namespace-require
             'vr-cabin/run-lang)
            
            (current-namespace))))

  (when (not runner)
    (set! runner
          (thread
           (thunk
            (let loop ()
              (map (lambda (k)
                     (displayln (~a "  Ticking for: " k))
                     (define p (hash-ref current-programs k))

                     (p))
                   (hash-keys current-programs))

              (displayln "Ticked all programs.  Resting a bit.")
              (sleep 1)
              (loop))))))
  
  (displayln "Ending def..."))




(define/contract (get-spell spell-id)
  (-> integer? list?)
 
  (local-require net/http-easy
                 json)

  (define id spell-id)
  (define twitch-id (current-twitch-id))
  
  (define res
    (get
     (~a "https://guarded-mesa-01320.herokuapp.com/secret/"
         id)))
  (define payload
    (response-json res))
  (define code-string
    (~a
     "(let () "
     (hash-ref payload 'text)
     ")"))
  (define code
    (read (open-input-string code-string)))

  code)

(define/contract (run spell-id)
  (-> integer? string?)
  (setup-ns)
  (if (not (hash-has-key? current-minis (current-twitch-id)))
      @~a{You don't have a mini yet!}
      (let ()
        (define code
          (get-spell spell-id))

        (with-handlers
            ([exn:fail? (lambda (e) (~a e))])

          (define program
            (eval
             `(generator ()
                         (with-mini ,(hash-ref current-minis (current-twitch-id))
                           ,code))
             safe-ns))

          (set! current-programs
                (hash-set current-programs
                          (current-twitch-id)
                          program))
          
          @~a{Running your spell... @code}))))

(define/contract (show-spell spell-id)
  (-> integer? string?)

  (if (not (hash-has-key? current-minis (current-twitch-id)))
      @~a{You don't have a mini yet!}
      (let ()
        
        (define code
          (get-spell spell-id))

        @~a{This is your code: @code})
      ))
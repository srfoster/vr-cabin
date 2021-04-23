#lang racket/base
;taskkill" /T /IM "node" /F

(require twitch-bot
         vr-cabin/chat
         unreal)

(bootstrap-unreal-js  
 "Build\\WindowsNoEditor\\LogCabinWorld\\Content\\Scripts")

(start-unreal 
 "Build\\WindowsNoEditor\\CodeSpellsDemoWorld.exe")

(define (prep-for-chat-output v)
  (if (unreal-actor? v)
      "[Unreal Actor]" ;Snip it.  Too long
      v))

(define e (make-safe-evaluator 'vr-cabin/chat))

(start-twitch-bot
 (handle-twitch-message
  (lambda (expr)

    (define evaled
      ((use-evaluator e) expr))

    (define ret
      (prep-for-chat-output
       evaled))

    ret)))
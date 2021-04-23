#lang at-exp racket

(provide mini
         force
         let
         #%app
         #%top
         #%module-begin
         #%top-interaction
         #%datum)

(require unreal)

(define (mini twitch-id)
  (define js
    @unreal-value{
 var Mini = Root.ResolveClass('PickupMini');
 var mini = new Mini(GWorld,{X: 640, Y: -360, Z: 186});
 mini.ChangeName('@twitch-id');

 return mini;
 })

  js)

(define (force mini x y z)
  @unreal-value{
 var mini = @(->unreal-value mini);
 mini.AddForce({X:@x,Y:@y,Z:@z})

 return true
 })
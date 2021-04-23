#lang at-exp racket

(provide mini
         force
         color
         let
         #%app
         #%top
         #%module-begin
         #%top-interaction
         #%datum)

(require unreal)

(define/contract (mini twitch-id)
  (-> string? unreal-value?)
  
  (define js
    @unreal-value{
 var Mini = Root.ResolveClass('PickupMini');
 var mini = new Mini(GWorld,{X: 640, Y: -360, Z: 186});
 mini.ChangeName(@(->unreal-value twitch-id));

 return mini;
 })

  js)

(define (color mini col)
   @unreal-value{
 var mini = @(->unreal-value mini);
 mini.ChangeColor(ParticleSystem.Load("/Game/Orbs/" + @(~s (string-titlecase col)) + "Orb"))
 })

(define/contract (force mini x y z)
  (-> any/c number? number? number? unreal-value?)
  
  @unreal-value{
 var mini = @(->unreal-value mini);
 mini.AddForce({X:@x,Y:@y,Z:@z})

 return true
 })
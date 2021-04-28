#lang at-exp racket

(provide spawn
         respawn
         force
         force-to
         anchor
         color
         let
         green
         red
         blue
         orange
         
         #%app
         #%top
         #%module-begin
         #%top-interaction
         #%datum)

(require unreal
         unreal/libs/names)

(define/contract (spawn twitch-id)
  (-> string? unreal-value?)
  
  (define js
    @unreal-value{
 var Spawn = Root.ResolveClass('PickupMini');
 var spawn = new Spawn(GWorld,{X: 640, Y: -360, Z: 186});
 spawn.ChangeName(@(->unreal-value twitch-id));

 return spawn;
 })

  (with-name twitch-id js))

(define (respawn spawn)
   @unreal-value{
 var spawn = @(->unreal-value spawn);
 spawn.SetActorLocation({X: 640, Y: -360, Z: 186});
 return spawn;
 })

(define (color spawn col)
   @unreal-value{
 var spawn = @(->unreal-value spawn);
 spawn.ChangeColor(ParticleSystem.Load("/Game/Orbs/" + @(~s (string-titlecase col)) + "Orb"));
 return spawn;
 })

(define/contract (force spawn x y z)
  (-> any/c number? number? number? unreal-value?)
  
  @unreal-value{
 var spawn = @(->unreal-value spawn);
 spawn.AddForce({X:@x,Y:@y,Z:@z})

 return true
 })

(define/contract (force-to spawn name mag)
  (-> any/c string? number? unreal-value?)
  
  @unreal-value{
 var spawn = @(->unreal-value spawn);
 var obj = @(with-name name);
 var spawnCoords = spawn.GetActorLocation();
 var objCoords = obj.GetActorLocation();
 var vect = {X: (objCoords.X - spawnCoords.X),
             Y: (objCoords.Y - spawnCoords.Y),
             Z: (objCoords.Z - spawnCoords.Z)};
 var magnitude = Math.sqrt(Math.pow(vect.X,2) +
                           Math.pow(vect.Y,2) +
                           Math.pow(vect.X,2))
 var vect2 = {X: (vect.X / magnitude) * @mag,
              Y: (vect.Y / magnitude) * @mag,
              Z: (vect.Z / magnitude) * @mag};
 spawn.AddForce(vect2);
 })

(define/contract (anchor spawn name)
  (-> any/c string? unreal-value?)
  
  @unreal-value{
 var spawn = @(->unreal-value spawn);
 var obj = @(with-name name);
 spawn.AddChild(obj);
 })

(define green
  "green")
(define blue
  "blue")
(define red
  "red")
(define orange
  "orange")
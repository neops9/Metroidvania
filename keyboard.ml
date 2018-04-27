open Tsdl
open Character
open Sound
open Scene
open Animation
open Gameobject
open Player
open Tool

let keyboard_actions s = 
  let keystates = Sdl.get_keyboard_state () in
  let player = ref (Scene.get_player s) in
  if (keystates.{ Tool.scancode "up" } != 0) && not (!player).in_air && (!player).vy = 0.0
  then 
    begin
      Sound.play (Tool.get_sound_from_list (!player).sounds "jump");
      if (!player).current_animation.name = "hurt" && (!player).current_animation.loop > 0
      then
        begin
          player := { !player with in_air = true;
                                   vy = -12.1 };
        end
      else
        begin
          player := { !player with current_animation = get_animation_from_list (!player).animations "jump";
                                   in_air = true;
                                   vy = -12.1 };
        end
    end;
  
  if (keystates.{ Tool.scancode "left" } != 0)
  then
    player := { !player with vx = -7; flip = true };
  
  if keystates.{ Tool.scancode "right" } != 0
  then
    player := { !player with vx = 7; flip = false };
  
  if (keystates.{ Tool.scancode "a" } != 0 && ((!player).reload_time <= 0))
  then
    begin
      Sound.play (Tool.get_sound_from_list (!player).sounds "throw");
      if (!player).flip
      then
        begin
          let projectile = Gameobject.create "projectile" ((!player).x - 10) ((!player).y + 50) (-8) (-10.1) (!player).projectile [(!player).projectile] true false 1 1000 [] true in
          if (!player).current_animation.name = "hurt" && (!player).current_animation.loop > 0
          then
            begin
              player := { !player with reload_time = 20;
                                       projectiles = projectile::((!player).projectiles) };
            end
          else
            begin
              player := { !player with current_animation = get_animation_from_list (!player).animations "throw";
                                       reload_time = 20;
                                       projectiles = projectile::((!player).projectiles) };
            end
        end
      else
        begin
          let projectile = Gameobject.create "projectile" ((!player).x + 50) ((!player).y + 50) 8 (-10.1) (!player).projectile [(!player).projectile] true false 1 1000 [] true in
          if (!player).current_animation.name = "hurt" && (!player).current_animation.loop > 0
          then
            begin
              player := { !player with reload_time = 20;
                                       projectiles = projectile::((!player).projectiles) };
            end
          else
            begin
              player := { !player with current_animation = get_animation_from_list (!player).animations "throw";
                                       reload_time = 20;
                                       projectiles = projectile::((!player).projectiles) };
            end
        end
    end;
  
  if keystates.{ Tool.scancode "left" } = 0 && keystates.{ Tool.scancode "right" } = 0
  then
    player := { !player with vx = 0 };

  { s with player = !player }
;;

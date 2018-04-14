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
  let p = (Scene.get_player s) in
  if (keystates.{ Tool.scancode "up" } <> 0) && not p.in_air && p.vy = 0.0 then 
    begin
      Sound.play (Tool.get_sound_from_list (Player.get_sounds p) "jump");
      { s with player = { p with current_animation = get_animation_from_list p.animations "jump"; in_air = true; vy = -12.1 } } 
    end
  else if keystates.{ Tool.scancode "left" } <> 0 then
    { s with player = { p with vx = -7; flip = true } }
  else if keystates.{ Tool.scancode "right" } <> 0 then
    { s with player = { p with vx = 7; flip = false } }
  else if (keystates.{ Tool.scancode "a" } <> 0 && (p.reload_time <= 0)) then
    begin
      Sound.play (Tool.get_sound_from_list p.sounds "throw");
      if p.flip then
        let projectile = Gameobject.create "projectile" (p.x - 50) (p.y + 50) (-8) (-10.1) p.projectile [p.projectile] true false 1 1000 [] true in
        { s with player = { p with reload_time = 20; projectiles = projectile::(p.projectiles) } }
      else
        let projectile = Gameobject.create "projectile" (p.x + 50) (p.y + 50) 8 (-10.1) p.projectile [p.projectile] true false 1 1000 [] true in
        { s with player = { p with reload_time = 20; projectiles = projectile::(p.projectiles) } }
    end
  else if keystates.{ Tool.scancode "right" } = 0 then
    { s with player = { p with vx = 0} }
  else if keystates.{ Tool.scancode "left" } = 0 then
    { s with player = { p with vx = 0} }
  else
    s
;;

open Tsdl
open Objet
open Sound
open Scene

let keyboard_actions s = 
  let keystates = Sdl.get_keyboard_state () in
  let p = (get_player s) in
  if (keystates.{ Tool.scancode "up" } <> 0) && not (Objet.is_in_air p) && (Objet.get_vy p) = 0. then begin
    play_sound (Objet.get_sound p "jump") ;
    { s with player = { p with in_air = true; vy = -12. } } end
  else if keystates.{ Tool.scancode "left" } <> 0 then
    { s with player = { p with vx = -10; frame = (((Objet.get_frame p)+1) mod 25); flip = true } }
  else if keystates.{ Tool.scancode "right" } <> 0 then
    { s with player = { p with vx = 10; frame = (((Objet.get_frame p)+1) mod 25); flip = false } }
  else if (keystates.{ Tool.scancode "a" } <> 0 && ((get_bullet_time p) <= 0)) then
    begin
      play_sound (Objet.get_sound p "throw") ;
      if Objet.is_flip p then 
        let bullet = Objet.create ((Objet.get_x p) - 50) ((Objet.get_y p) + 50) (Tool.create_texture_from_image (get_renderer s) "images/rock.bmp") (-10.) (-8) 34 34 0 1000 false false false 0 [] true in
        { s with player = { p with bullet_time = 20 } ; object_list = bullet::(s.items) }
      else
        let bullet = Objet.create ((Objet.get_x p) + 100) ((Objet.get_y p) + 50) (Tool.create_texture_from_image (get_renderer s) "images/rock.bmp") (-10.) 8 34 34 0 1000 false false false 0 [] true in
        { s with player = { p with bullet_time = 20 } ; object_list = bullet::(s.items) }
    end
  else if keystates.{ Tool.scancode "right" } = 0 then
    { s with player = Objet.set_vx p 0 }
  else if keystates.{ Tool.scancode "left" } = 0 then
    { s with player = Objet.set_vx p 0 }
  else
    s
;;

open Tsdl
open Tsdl_mixer
open Result
open Sound
open Animation
open Gameobject
open Tool

type character = { name : string;
                   x : int; 
                   y : int; 
                   vx : int; 
                   vy : float; 
                   current_animation : animation;
                   animations : animation list;
                   sounds : sound list;
                   projectile : animation;
                   projectiles : gameobject list;
                   flip : bool;
                   life : int;
                   collision : bool;
                   reload_time : int; 
                   invulnerable_time : int; 
                   in_air : bool;
                   has_moved : bool }
;;

let create name x y vx vy current_animation animations sounds projectile flip life = { name; x; y; vx; vy; current_animation; animations; sounds; projectile; projectiles = []; flip; life; collision = true; reload_time = 0; invulnerable_time = 0; in_air = false; has_moved = false } ;;

let get_x c = c.x ;;
let get_y c = c.y ;;
let get_dx c = c.current_animation.dx ;;
let get_dy c = c.current_animation.dy ;;
let get_current_animation c = c.current_animation ;;
let get_texture c = Animation.get_texture c.current_animation ;;
let is_collision c = c.collision ;;

let character_to_rect c = Sdl.Rect.create c.x c.y c.current_animation.dx c.current_animation.dy ;;

let rec update_projectiles c = { c with projectiles = List.fold_left (fun acc x -> if (Gameobject.get_life_time x) <= 0 then acc else (Gameobject.update x)::acc) [] c.projectiles } ;;

let update c =
let c = update_projectiles c in
if not (c.vy = 0.) then 
  { c with vy = c.vy +. 0.5; current_animation = Animation.update c.current_animation; projectile = Animation.update c.projectile; reload_time = c.reload_time - 1; invulnerable_time = c.invulnerable_time - 10 } 
else 
  { c with current_animation = Animation.update c.current_animation; reload_time = c.reload_time - 1; projectile = Animation.update c.projectile; invulnerable_time = c.invulnerable_time - 10 } 
;;

let rec display r c o =  
  let rect = (Sdl.Rect.create (o.x - (Sdl.Rect.x c))  (o.y - (Sdl.Rect.y c)) o.current_animation.dx o.current_animation.dy) in
  let texture = Animation.get_texture o.current_animation in
  if o.flip then
    match Sdl.render_copy_ex ~dst:rect r texture 0. None Sdl.Flip.horizontal with
    | Error (`Msg e) ->  Sdl.log "Can't fill image error: %s" e; exit 1 
    | Ok () -> List.iter (Gameobject.display r c) (o.projectiles);
  else
    match Sdl.render_copy ~dst:rect r texture with
    | Error (`Msg e) ->  Sdl.log "Can't fill image error: %s" e; exit 1 
    | Ok () -> List.iter (Gameobject.display r c) (o.projectiles);
;;

let play_action c =
  if c.reload_time <= 0 then 
  begin 
    let projectile = Gameobject.create "projectile" (c.x - 50) (c.y + 50) (-8) (-10.) c.projectile [c.projectile] true false 1 1000 [] true in
    { c with reload_time = 40; projectiles = projectile::(c.projectiles) }
  end
  else
    c
;;

let move l c =
  if (c.vx = 0) && (c.vy = 0.) then c
  else
  begin
  let c_x = { c with x = c.x + c.vx } in
  if collision (character_to_rect c_x) l
  then
    begin
	  let c_y = { c with y = c.y + int_of_float(c.vy) } in
	  if collision (character_to_rect c_y) l then { c with projectiles = List.map (Gameobject.move l) (c.projectiles) }
	  else { c_y with projectiles = List.map (Gameobject.move l) (c_y.projectiles) }
    end
  else
    begin
      let c_x_y = { c_x with y = c_x.y + int_of_float(c_x.vy) } in
      if collision (character_to_rect c_x_y) l then { c_x with projectiles = List.map (Gameobject.move l) (c_x.projectiles) }
      else { c_x_y  with projectiles = List.map (Gameobject.move l) (c_x_y.projectiles) }
    end
    end
;;

let destroy c = Animation.destroy c.current_animation; List.iter (Animation.destroy) c.animations; Animation.destroy c.projectile ;;

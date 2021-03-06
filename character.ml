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
                   in_air : bool; }
;;

let create name x y vx vy current_animation animations sounds projectile flip life = { name;
                                                                                       x;
                                                                                       y;
                                                                                       vx;
                                                                                       vy;
                                                                                       current_animation;
                                                                                       animations;
                                                                                       sounds;
                                                                                       projectile;
                                                                                       projectiles = [];
                                                                                       flip;
                                                                                       life;
                                                                                       collision = true;
                                                                                       reload_time = 0;
                                                                                       invulnerable_time = 0;
                                                                                       in_air = false } ;;

let get_x c = c.x ;;
let get_y c = c.y ;;
let get_vx c = c.vx ;;
let get_vy c = c.vy ;;
let get_dx c = c.current_animation.dx ;;
let get_dy c = c.current_animation.dy ;;
let get_current_animation c = c.current_animation ;;
let get_texture c = Animation.get_texture c.current_animation ;;
let is_collision c = c.collision ;;
let get_projectiles c = c.projectiles ;;
let get_name c = c.name ;;

let character_to_rect c = Sdl.Rect.create c.x c.y c.current_animation.dx c.current_animation.dy ;;

let rec update_projectiles c = { c with projectiles = List.fold_left (fun acc x -> if (Gameobject.get_life_time x) <= 0
                                                                                   then acc
                                                                                   else (Gameobject.update x)::acc) [] c.projectiles }
;;

let int_of_bool b = if b then -1 else 1 ;;

let projectile_x b = if b then -60 else 100 ;;

let update c =
  let c = update_projectiles c in
  if c.vy != 0. then 
    begin
      if c.current_animation.name = "hurt" && c.current_animation.loop <= 0
      then
        { c with vy = c.vy +. 0.5;
                 current_animation = get_animation_from_list c.animations "run";
                 projectile = Animation.update c.projectile;
                 reload_time = c.reload_time - 1;
                 invulnerable_time = c.invulnerable_time - 10 } 
      else
        { c with vy = c.vy +. 0.5;
                 current_animation = Animation.update c.current_animation;
                 projectile = Animation.update c.projectile;
                 reload_time = c.reload_time - 1;
                 invulnerable_time = c.invulnerable_time - 10 } 
    end
  else 
    begin
      if c.current_animation.name = "hurt" && c.current_animation.loop <= 0
      then
        { c with current_animation = get_animation_from_list c.animations "run";
                 reload_time = c.reload_time - 1;
                 projectile = Animation.update c.projectile;
                 invulnerable_time = c.invulnerable_time - 10 } 
      else
        { c with current_animation = Animation.update c.current_animation;
                 reload_time = c.reload_time - 1;
                 projectile = Animation.update c.projectile;
                 invulnerable_time = c.invulnerable_time - 10 } 
    end
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

let play_action p c =
  if dist_2d (Sdl.Rect.x p) c.x (Sdl.Rect.y p) c.y <= 300.
  then
    begin
      if c.reload_time <= 0
      then 
        begin
          if (Sdl.Rect.x p) < c.x
          then
            begin
	      let projectile = Gameobject.create "projectile" (c.x + (projectile_x true)) (c.y + 10) (8 * (int_of_bool true)) (-10.1) c.projectile [c.projectile] true false 1 1000 [] true in
	      { c with vx = 0;
                       flip = true;
                       current_animation = get_animation_from_list c.animations "throw";
                       reload_time = 50;
                       projectiles = projectile::(c.projectiles) }
	    end
	  else
	    begin
	      let projectile = Gameobject.create "projectile" (c.x + (projectile_x false)) (c.y + 10) (8 * (int_of_bool false)) (-10.1) c.projectile [c.projectile] true false 1 1000 [] true in
	      { c with vx = 0;
                       flip = false;
                       current_animation = get_animation_from_list c.animations "throw";
                       reload_time = 50;
                       projectiles = projectile::(c.projectiles) }
	    end
        end
      else c
    end
  else
    begin
      if c.vx = 0
      then
        begin
          if c.flip
          then { c with vx = -2;
                        current_animation = get_animation_from_list c.animations "run" }
          else { c with vx = 2;
                        current_animation = get_animation_from_list c.animations "run" }
        end
      else c
    end
;;

let move l c =
  if (c.vx = 0) && (c.vy = 0.)
  then { c with projectiles = List.map (Gameobject.move l) (c.projectiles) }
  else
    begin
      let c_x = { c with x = c.x + c.vx } in
      if collision_rec (character_to_rect c_x) l
      then
        begin
	  let c_y = { c with y = c.y + int_of_float(c.vy) } in
	  if collision_rec (character_to_rect c_y) l
          then
            { c with vx = (-1)*c.vx;
                     flip = not (c.flip);
                     vy = 0.;
                     projectiles = List.map (Gameobject.move l) (c.projectiles) }
	  else
            { c_y with projectiles = List.map (Gameobject.move l) (c_y.projectiles) }
        end
      else
        begin
          let c_x_y = { c_x with y = c_x.y + int_of_float(c_x.vy) } in
          if collision_rec (character_to_rect c_x_y) l
          then
            { c_x with vy = 0.;
                       projectiles = List.map (Gameobject.move l) (c_x.projectiles) }
          else
            { c_x_y  with projectiles = List.map (Gameobject.move l) (c_x_y.projectiles) }
        end
    end
;;

let destroy c = Animation.destroy c.current_animation;
                List.iter (Animation.destroy) c.animations;
                Animation.destroy c.projectile
;;

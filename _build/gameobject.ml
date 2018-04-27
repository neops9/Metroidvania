open Tsdl
open Tsdl_mixer
open Result
open Sound
open Animation
open Tool

type gameobject = { name : string;
				    x : int;
                    y : int; 
                    vx : int; 
                    vy : float; 
                    current_animation : animation;
                    animations : animation list; 
                    collision : bool; 
                    flip : bool;
                    life : int;
                    life_time : int;
                    sounds : sound list;
                    projectiles : gameobject list;
                    is_projectile : bool }
;;

let create name x y vx vy current_animation animations collision flip life life_time sounds is_projectile = { name; x; y; vx; vy; current_animation; animations; collision; flip; life; life_time; sounds; projectiles = []; is_projectile } ;;

let get_x o = o.x ;;
let get_y o = o.y ;;
let get_vx o = o.vx ;;
let get_vy o = o.vy ;;
let get_current_animation o = o.current_animation ;;
let get_life_time o = o.life_time ;;
let get_dx c = c.current_animation.dx ;;
let get_dy c = c.current_animation.dy ;;
let get_texture c = Animation.get_texture c.current_animation ;;
let is_collision o = o.collision ;;
let get_projectiles o = o.projectiles ;;

let gameobject_to_rect o = Sdl.Rect.create o.x o.y o.current_animation.dx o.current_animation.dy ;;

let rec move l o =
if (o.vx = 0) && (o.vy = 0.) then o
else
begin
  let o_x = { o with x = o.x + o.vx } in
  if collision_rec (gameobject_to_rect o_x) l
  then
    if o.is_projectile then { o with life_time = 0 } else
      begin
	    let o_y = { o with y = o.y + int_of_float(o.vy) } in
	    if collision_rec (gameobject_to_rect o_y) l then { o with projectiles = List.map (move l) (o.projectiles) }
	    else { o_y with projectiles = List.map (move l) (o_y.projectiles) }
      end
  else
    let o_x_y = { o_x with y = o_x.y + int_of_float(o_x.vy) } in
    if collision_rec (gameobject_to_rect o_x_y) l then 
      begin
        if o.is_projectile then { o with life_time = 0 } else { o_x with projectiles = List.map (move l) (o_x.projectiles) }
      end
    else { o_x_y with projectiles = List.map (move l) (o_x_y.projectiles) }
    end
;;

let rec update_projectiles o = { o with projectiles = List.fold_left (fun acc x -> if x.life_time <= 0 then acc else ({ x with vy = x.vy +. 0.5; current_animation = Animation.update x.current_animation; life_time = x.life_time - 10 })::acc) [] o.projectiles } ;;

let update o = 
let o = update_projectiles o in
if not (o.vy = 0.0) then
  { o with vy = o.vy +. 0.5; current_animation = Animation.update o.current_animation; life_time = o.life_time - 10 }
else 
  { o with current_animation = Animation.update o.current_animation; life_time = o.life_time - 10 }
;;

let rec display r c o =  
  let rect = (Sdl.Rect.create (o.x - (Sdl.Rect.x c))  (o.y - (Sdl.Rect.y c)) o.current_animation.dx o.current_animation.dy) in
  let texture = Animation.get_texture o.current_animation in
  if o.flip then
    match Sdl.render_copy_ex ~dst:rect r texture 0. None Sdl.Flip.horizontal with
    | Error (`Msg e) ->  Sdl.log "Can't fill image error: %s" e; exit 1 
    | Ok () -> List.iter (display r c) (o.projectiles);
  else
    match Sdl.render_copy ~dst:rect r texture with
    | Error (`Msg e) ->  Sdl.log "Can't fill image error: %s" e; exit 1 
    | Ok () -> List.iter (display r c) (o.projectiles);
;;

let destroy o = Animation.destroy o.current_animation; List.iter (Animation.destroy) o.animations ;;

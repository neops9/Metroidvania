open Tsdl
open Tsdl_mixer
open Result
open Sound
open Tool
open Animation
open Gameobject
open Character

type player = { name : string;
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
                has_moved : bool;
                heart_texture : Sdl.texture;
                damaged_characters : character list }
;;

let create name x y vx vy current_animation animations sounds projectile flip life heart_texture = { name; x; y; vx; vy; current_animation; animations; sounds; projectile; projectiles = []; flip; life; collision = true; reload_time = 0; invulnerable_time = 0; in_air = false; has_moved = false; heart_texture; damaged_characters = [] } ;;

let get_life p = p.life ;;
let get_x p = p.x ;;
let get_y p = p.y ;;
let get_dx p = p.current_animation.dx ;;
let get_dy p = p.current_animation.dy ;;
let get_texture p = Animation.get_texture p.current_animation ;;
let is_in_air p = p.in_air ;;
let get_vy p = p.vy ;;
let get_sounds p = p.sounds ;;
let get_current_animation p = p.current_animation ;;
let get_projectiles p = p.projectiles ;;

let player_to_rect p = Sdl.Rect.create p.x p.y p.current_animation.dx p.current_animation.dy ;;

let rec update_projectiles p = { p with projectiles = List.fold_left (fun acc x -> if x.life_time <= 0 then acc else (Gameobject.update x)::acc) [] p.projectiles } ;;

let update p =
let p = update_projectiles p in
if p.y > 850 then 
  begin
    Sound.play (get_sound_from_list p.sounds "lose");
    { p with x = 10 ; y = 600 ; life = p.life - 1 ; invulnerable_time = 0} 
  end 
else if not (p.vy = 0.) then 
  { p with vy = p.vy +. 0.5; current_animation = Animation.update p.current_animation; projectile = Animation.update p.projectile; reload_time = p.reload_time - 1; invulnerable_time = p.invulnerable_time - 10 } 
else
  if p.vx != 0 then
  begin
  if p.current_animation.name = "run" then
    { p with vy = p.vy +. 0.5; current_animation = Animation.update p.current_animation; reload_time = p.reload_time - 1; projectile = Animation.update p.projectile; invulnerable_time = p.invulnerable_time - 10 }
  else
    { p with vy = p.vy +. 0.5; current_animation = get_animation_from_list p.animations "run"; reload_time = p.reload_time - 1; projectile = Animation.update p.projectile; invulnerable_time = p.invulnerable_time - 10 }
  end
  else 
  begin
  if p.current_animation.name = "run" || p.current_animation.name = "jump" then
    { p with vy = p.vy +. 0.5; current_animation = get_animation_from_list p.animations "idle"; reload_time = p.reload_time - 1; projectile = Animation.update p.projectile; invulnerable_time = p.invulnerable_time - 10 }
  else
    { p with vy = p.vy +. 0.5; current_animation = Animation.update p.current_animation; reload_time = p.reload_time - 1; projectile = Animation.update p.projectile; invulnerable_time = p.invulnerable_time - 10 }
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

let collision_with_character l p cl damage = 
   if damage then
     begin
       let damaged = List.fold_left (fun acc c -> if collision (player_to_rect p) (character_to_rect c) then (c::acc) else acc) [] cl in
       if damaged != [] then
       begin
         Sound.play (Tool.get_sound_from_list p.sounds "jump");
         { p with current_animation = get_animation_from_list p.animations "jump"; in_air = true; vy = -12.; damaged_characters = damaged; projectiles = List.map (Gameobject.move l) (p.projectiles) }
       end
       else
         p
     end
   else
     p
;;

let move l cl c =
if (c.vx = 0) && (c.vy = 0.) then c
else begin
  let c_x = { c with x = c.x + c.vx } in
  if collision_rec (player_to_rect c_x) l
  then
    begin
	  let c_y = { c with y = c.y + int_of_float(c.vy) } in
	  if collision_rec (player_to_rect c_y) l then
	    let c_y = collision_with_character l c_y cl true in 
	      if c_y.damaged_characters != [] then c_y else
	      begin
	        if c.vy >= 0. then { c with in_air = false; vy = 0.; projectiles = List.map (Gameobject.move l) (c.projectiles) } 
	        else { c with vy = 0.; projectiles = List.map (Gameobject.move l) (c.projectiles) } 
	      end
	  else { c_y with projectiles = List.map (Gameobject.move l) (c_y.projectiles) }
    end
  else
    begin
      let c_x_y = { c_x with y = c_x.y + int_of_float(c_x.vy) } in
      if collision_rec (player_to_rect c_x_y) l then 
        begin 
          let c_x_y = collision_with_character l c_x_y cl true in
            if c_x_y.damaged_characters != [] then c_x_y else
            begin
              if c.vy >= 0. then { c_x with in_air = false; vy = 0.; projectiles = List.map (Gameobject.move l) (c_x.projectiles) } 
              else { c_x with vy = 0.; projectiles = List.map (Gameobject.move l) (c_x.projectiles) } 
            end
        end
      else { c_x_y with projectiles = List.map (Gameobject.move l) (c_x_y.projectiles) }
    end
    end
;;

let destroy p = Animation.destroy p.current_animation; List.iter (Animation.destroy) p.animations; Animation.destroy p.projectile; Sdl.destroy_texture p.heart_texture ;;

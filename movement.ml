open Tsdl
open Scene
open Objet
open Tool
open Tsdl_mixer

let rec collision sce o l =
  match l with
  | [] -> false
  | x::s -> if not (Objet.equals o { x with x = ((Objet.get_x x) + (Objet.get_vx x)) }) then
              begin 
                if (Objet.get_life_time) o <= 1000 && Sdl.has_intersection (objet_to_rect o) (objet_to_rect x) && not (Objet.is_character x) && (Objet.is_collision x) then true else if (Objet.get_life_time) o > 1000 && Sdl.has_intersection (objet_to_rect o) (objet_to_rect x) && (Objet.is_collision x) && (Objet.is_collision o) then true else collision sce o s 
              end
            else
              collision sce o s
;;

let rec bullet_collision o l =
  if not (Objet.is_character o) then o
  else match l with
       | [] -> o
       | x::next -> if not (Objet.is_bullet x) then bullet_collision o next else if Sdl.has_intersection (objet_to_rect o) (objet_to_rect x) && ((Objet.get_invulnerable o) <= 0) then { o with life = (Objet.get_life o) - 1; invulnerable = 300 } else bullet_collision o next
;;

let rec player_collision s o player l =
  if not (Objet.equals o player) then begin if (Objet.get_vy o) >= 0. then
	    Objet.set_vy (Objet.set_in_air o false) 0.
	  else
	    Objet.set_vy o 0. end
  else 
match l with
       | [] -> begin if (Objet.get_vy o) >= 0. then
	    Objet.set_vy (Objet.set_in_air o false) 0.
	  else
	    Objet.set_vy o 0. end
       | x::next -> if Sdl.has_intersection (objet_to_rect { o with y = ((Objet.get_y o) + int_of_float(Objet.get_vy o)) }) (objet_to_rect x) then begin Mixer.play_channel (-1) (Objet.get_sound player "jump") 0; { o with in_air = true; vy = (-10.) } end else player_collision s o player next
;;

let move_object s p o =
  let o = bullet_collision o (Scene.get_objects s) in
  let o_x = Objet.update_pos o (Objet.get_x o + Objet.get_vx o) (Objet.get_y o) in
  if collision s o_x (Scene.get_objects s) || collision s o_x (Scene.get_characters s) || collision s o_x [p]
  then
    if (Objet.get_life_time) o <= 1000 then Objet.set_life_time o 0 else
      begin
	let o_y = Objet.update_pos o (Objet.get_x o) ((Objet.get_y o) + int_of_float(Objet.get_vy o)) in 
	if collision s o_y (Scene.get_objects s) || collision s o_y (Scene.get_characters s)
	then
	  player_collision s o (Objet.update_pos (Scene.get_player s) (Objet.get_x (Scene.get_player s)) ((Objet.get_y (Scene.get_player s)))) (Scene.get_characters s)
	else o_y
      end
  else
    let o_x_y =  Objet.update_pos o_x (Objet.get_x o_x) ((Objet.get_y o_x) + int_of_float(Objet.get_vy o_x)) in
    if collision s o_x_y (Scene.get_objects s) || collision s o_x_y (Scene.get_characters s) || collision s o_x_y [p] then 
      begin
        if (Objet.get_life_time) o <= 1000 
        then Objet.set_life_time o 0 
        else
	  player_collision s o_x (Objet.update_pos (Scene.get_player s) (Objet.get_x (Scene.get_player s) + Objet.get_vx (Scene.get_player s)) ((Objet.get_y (Scene.get_player s)))) (Scene.get_characters s)
      end
    else o_x_y 
;;

let characters_action s =
  let rec characters_throw l chars sce =
    match l with
    | [] -> sce
    | c::next -> if Objet.get_bullet_time c <= 0 then begin let bullet = Objet.create ((Objet.get_x c) - 50) ((Objet.get_y c) + 50) (Tool.create_texture_from_image (Scene.get_renderer sce) "images/rock.bmp") (-10.) (-8) 34 34 0 1000 false false false 0 [] true in
                                                            characters_throw next (({ c with bullet_time = 40})::chars) { sce with object_list = bullet::(sce.object_list) ; character_list = ({ c with bullet_time = 40})::chars }
                                                      end
                 else
                   characters_throw next (c::chars) { sce with character_list = (c::chars) }
  in 
  characters_throw (Scene.get_characters s) [] s
;;

let move_scene s p =
  if (Objet.get_x p > (Scene.get_width s) + 300) then
    Scene.change_scene s (Scene.get_next_scene s) p 10
  else if (Objet.get_x p < 0) then
    Scene.change_scene s (Scene.get_prev_scene s) p 2280
  else
    characters_action {s with object_list = List.map (move_object s p) (List.fold_left (fun acc x -> if Objet.get_life_time x > 1000 
												     then x::acc 
                                                                                                     else 
                                                                                                       begin 
                                                                                                         let o_bis = { x with life_time = ((Objet.get_life_time x) - 10); vy = ((Objet.get_vy x) +. 0.5) } in if Objet.get_life_time o_bis = 0 || Objet.get_life_time o_bis < (-1) 
                                                                                                                                                                                                              then acc 
                                                                                                                                                                                                              else o_bis::acc 
                                                                                                       end) [] (Scene.get_objects s));
                              
character_list = List.map (move_object s p) (List.fold_left (fun acc x -> if Objet.get_life x > 0 then x::acc else acc) [] (List.map (fun x -> { x with vy = ((Objet.get_vy x) +. 0.5); bullet_time = (Objet.get_bullet_time x) - 1; invulnerable = x.invulnerable - 10}) (Scene.get_characters s)))

}
;;

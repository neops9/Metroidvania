open Tsdl
open Scene
open Objet
open Tool

let rec collision sce o l =
  match l with
  | [] -> false
  | x::s -> if (Objet.get_life_time) o <= 1000 && Sdl.has_intersection (objet_to_rect o) (objet_to_rect x) && not (Objet.is_character x) && (Objet.is_collision x) then true else if (Objet.get_life_time) o > 1000 && Sdl.has_intersection (objet_to_rect o) (objet_to_rect x) && ((Objet.is_collision x) || (not (Objet.is_collision o) && not (Objet.is_character x))) then true else collision sce o s
;;

let move_object s o =
  let o_x = Objet.update_pos o (Objet.get_x o + Objet.get_vx o) (Objet.get_y o) in
  if collision s o_x (Scene.get_objects s) || collision s o_x (Scene.get_characters s)
  then
    if (Objet.get_life_time) o <= 1000 then Objet.set_life_time o 0 else
      begin
	let o_y = Objet.update_pos o (Objet.get_x o) ((Objet.get_y o) + int_of_float(Objet.get_vy o)) in 
	if collision s o_y (Scene.get_objects s) || collision s o_y (Scene.get_characters s)
	then
	  if (Objet.get_vy o) >= 0. then
	    Objet.set_vy (Objet.set_in_air o false) 0.
	  else
	    Objet.set_vy o 0.
	else o_y
      end
  else
    let o_x_y =  Objet.update_pos o_x (Objet.get_x o_x) ((Objet.get_y o_x) + int_of_float(Objet.get_vy o_x)) in 
    if collision s o_x_y (Scene.get_objects s) || collision s o_x_y (Scene.get_characters s) then begin
      if (Objet.get_life_time) o <= 1000 
      then Objet.set_life_time o 0 
      else
	begin
	  if (Objet.get_vy o_x) >= 0. then
	    Objet.set_vy (Objet.set_in_air o_x false) 0.
	  else
	    Objet.set_vy o_x 0. end
    end
    else o_x_y 
;;

let move_scene s p =
  if (Objet.get_x p > (Scene.get_width s) + 300) then
    Scene.change_scene s (Scene.get_next_scene s) p 10
  else if (Objet.get_x p < 0) then
    Scene.change_scene s (Scene.get_prev_scene s) p 2280
  else
  {s with object_list = List.map (move_object s) (List.fold_left (fun acc x -> let o_bis = Objet.set_life_time x ((Objet.get_life_time x) - 10) in if Objet.get_life_time o_bis <= 0 then acc else o_bis::acc) [] (Scene.get_objects s));
    character_list = List.map (move_object s) (Scene.get_characters s)} 
;;

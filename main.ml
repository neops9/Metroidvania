open Tsdl
open Result
open Objet
open Tool
open Scene

(*eval $(opam config env)*)
(*ocamlbuild -use-ocamlfind -package tsdl,tsdl_mixer main.byte*)

(* CTRL X / H / TAB *)

let window_width = 1600;;
let window_height = 1000;;

let camera_width = 640 ;;
let camera_height = 480 ;;

let c = Sdl.Rect.create 0 0 camera_width camera_height;;

let move_camera c s move_pers =
  Sdl.Rect.set_x c (((Objet.get_x move_pers) + 50/2) - window_width/2) ;
  
  if (Sdl.Rect.x c < 0)
  then
    begin
      let save_y = Sdl.Rect.y c in
      Sdl.Rect.set_x c 0 ; Sdl.Rect.set_y c (((Objet.get_y move_pers)) - window_height/2); 
      if Sdl.Rect.y c >= 0
      then
	begin
	  if Sdl.Rect.y c > (Scene.get_height s) - camera_height 
	  then
	    Sdl.Rect.set_y c ((Scene.get_height s) - camera_height);
	end
      else
        Sdl.Rect.set_y c save_y ;
    end
  else
    begin
      if Sdl.Rect.x c > (Scene.get_width s) - camera_width
      then
	begin
	  Sdl.Rect.set_x c ((Scene.get_width s) - camera_width) ;
	  Sdl.Rect.set_y c (((Objet.get_y move_pers)) - window_height/2) ;
	  if Sdl.Rect.y c < 0
	  then
	    Sdl.Rect.set_y c 0
	  else
	    if Sdl.Rect.y c > (Scene.get_height s) - camera_height
	    then Sdl.Rect.set_y c ((Scene.get_height s) - camera_height)
	    else ()
	end	  
      else
	begin
	  Sdl.Rect.set_y c (((Objet.get_y move_pers)) - window_height/2 -50) ;
	  if Sdl.Rect.y c < 0
	  then
	    Sdl.Rect.set_y c 0
	  else
	    if Sdl.Rect.y c > (Scene.get_height s) - camera_height then Sdl.Rect.set_y c ((Scene.get_height s) - camera_height)
	    else ()
	end
    end
;;

let rec collision sce o l =
  match l with
  | [] -> false
  | x::s -> if Sdl.has_intersection (objet_to_rect o) (objet_to_rect x) then true else collision sce o s
;;

let move s obj =
  let o_x = Objet.update_pos obj (Objet.get_x obj + Objet.get_vx obj) (Objet.get_y obj) in
  if collision s o_x (Scene.get_objects s) || collision s o_x (Scene.get_characters s)
  then 
    let o_y = Objet.update_pos obj (Objet.get_x obj) ((Objet.get_y obj) + int_of_float(Objet.get_vy obj)) in 
    if collision s o_y (Scene.get_objects s) || collision s o_y (Scene.get_characters s)
    then
      Objet.set_vy obj 0.
    else o_y
  else
    let o_x_y =  Objet.update_pos o_x (Objet.get_x o_x) ((Objet.get_y o_x) + int_of_float(Objet.get_vy o_x)) in 
    if collision s o_x_y (Scene.get_objects s) || collision s o_x_y (Scene.get_characters s) then Objet.set_vy o_x 0. else o_x_y ;;

let inAir obj s = if Objet.get_y obj = Objet.get_y (move s obj) then false else true ;;

let scene_move s p =
  if (Objet.get_x p) < 50 then s
  else
    {s with object_list = List.map (move s) (Scene.get_objects s);
      character_list = List.map (move s) (Scene.get_characters s)} ;;

let keyboard_down e s o = 
  if e = Sdl.K.space then (Objet.set_vy o (-12.))
  else if e = Sdl.K.up then (*if inAir o s then o else*) (Objet.set_vy o (-12.))
  else if e = Sdl.K.right then Objet.set_frame (Objet.set_vx o 10) (((Objet.get_frame o)+1) mod 5)
  else if e = Sdl.K.left then Objet.set_frame (Objet.set_vx o (-10)) (((Objet.get_frame o)+1) mod 5)
  else o				
;;

let keyboard_up e o = 
  if e = Sdl.K.right then (Objet.set_vx o 0)
  else if e = Sdl.K.left then (Objet.set_vx o 0)
  else o
;;

let rec wait p s r w c =
  let scene = scene_move s p in
  let pers_temp = Objet.set_vy p ((Objet.get_vy p) +. 0.5) in
  (*let pers_img = Objet.set_image ("char"^((string_of_int) (Objet.get_frame pers_temp))^".bmp") pers_temp in*) 
  let move_pers = (move scene pers_temp) in
  move_camera c scene move_pers;
  let event = Sdl.Event.create () in
  match Sdl.poll_event (Some(event)) with
  | false -> Sdl.render_clear r; Scene.display_scene scene r c; Tool.display_object [move_pers] r c; Sdl.render_present r; wait move_pers scene r w c
  | true -> match Sdl.Event.(enum (get event typ )) with
    |`Quit -> Sdl.destroy_window w; Sdl.quit ()
    | `Key_down -> let pers = keyboard_down (Sdl.Event.(get event keyboard_keycode)) scene move_pers in wait pers scene r w c
    | `Key_up -> let pers = keyboard_up (Sdl.Event.(get event keyboard_keycode)) move_pers in wait pers scene r w c
    | _ -> Sdl.render_clear r;  Scene.display_scene scene r c; Tool.display_object [move_pers] r c; Sdl.render_present r; wait move_pers scene r w c
;;

let main () = match Sdl.init Sdl.Init.video with
  | Error (`Msg e) -> Sdl.log "Init error: %s" e; exit 1
  | Ok () -> match Sdl.create_window ~w:window_width ~h:window_height "Metroidvania" Sdl.Window.opengl with
    | Error (`Msg e) -> Sdl.log "Create window error: %s" e; exit 1
    | Ok w -> match Sdl.create_renderer ~flags:Sdl.Renderer.(accelerated + presentvsync) w with
      | Error (`Msg e) ->  Sdl.log "Can't create renderer error: %s" e; exit 1
      | Ok r -> (*Sdl.set_window_resizable w true;*)
	 let ground_texture = Tool.create_texture_from_image r "ground.bmp" in
	 let caisse_texture = Tool.create_texture_from_image r "caisse.bmp" in
	 let ground = Objet.create 0 (1000 + 430) ground_texture 0. 0 800 50 0 in (* taille fenetre + position dans la scene*)
	 let ground2 = Objet.create 800 (1000 + 430) ground_texture 0. 0 800 50 0 in (* taille fenetre + position dans la scene*)
	 let tronc = Objet.create (250 )  (1000 + 230) (Tool.create_texture_from_image r "tronc.bmp") 0. 0 50 200 0 in
	 let touffe = Objet.create (225) (1150) (Tool.create_texture_from_image r "feuille.bmp") 0. 0 100 80 0 in
	 let caisse = Objet.create 50 700 caisse_texture 0. 0 120 80 0 in
	 let caisse2 = Objet.create 300 750 caisse_texture 0. 0 120 80 0 in
	 let liste_objet = [ caisse; caisse2; ground; tronc; touffe; ground2] in
	 let liste_objet2 = [ caisse2; ground; tronc; touffe ; ground2] in
	 let personnage = Objet.create 10 200 (Tool.create_texture_from_image r "char0.bmp") 0. 0 79 100 0 in
	 let liste_character = [] in
	 let s = Scene.create r liste_objet liste_character "test.bmp" 1280 960 in
	 wait personnage s r w c
;; 

let () = main () ;;

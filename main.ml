open Tsdl
open Result
open Objet
open Tool
open Scene

(*eval $(opam config env)*)
(*ocamlbuild -use-ocamlfind -package tsdl,tsdl_mixer main.byte*)

let caisse = Objet.create 100 200 "caisse.bmp" 0. 0 120 80;;
let caisse2 = Objet.create 300 10 "caisse.bmp" 0. 0 120 80;;
let liste_objet = [ caisse; caisse2 ] ;;
let liste_objet2 = [ caisse2 ] ;;

let personnage = Objet.create 0 2 "char1.bmp" 0. 0 50 100 ;;

let liste_character = [] ;;

let s = Scene.create liste_objet liste_character "test.bmp" ;;

let s2 = Scene.create liste_objet2 liste_character "test.bmp" ;;

let rec collision o l = match l with 
						| [] -> false
| x::s -> if (Objet.get_x o) = (Objet.get_x x) && (Objet.get_y o) = (Objet.get_y x) then false
								  else 
								  let right1 = (Objet.get_x o) + (Objet.get_dx o) in 
								  let right2 = (Objet.get_x x) + (Objet.get_dx x) in
								  let bottom1 = (Objet.get_y o) + (Objet.get_dy o) in
								  let bottom2 = (Objet.get_y x) + (Objet.get_dy x) in
								  if bottom1 <= (Objet.get_y x) or (Objet.get_y o) >= bottom2 or right1 <= (Objet.get_x x) or (Objet.get_x o) >= right2 then (collision o s) else true
;;

let move s obj = let o = Objet.update_pos obj (Objet.get_x obj + Objet.get_vx obj) ((Objet.get_y obj) + int_of_float(Objet.get_vy obj)) in if collision o (Scene.get_objects s) or collision o (Scene.get_characters s) then (if (Objet.get_vx obj) = 0 then Objet.set_vy 0. obj else Objet.set_vy ((Objet.get_vy obj) +. 0.5) (Objet.update_pos obj (Objet.get_x obj) ((Objet.get_y obj) + int_of_float(Objet.get_vy obj)))) else (if (Objet.get_y o) < 350 then Objet.set_vy ((Objet.get_vy o) +. 0.5) o else (Objet.set_vy 0. o)) ;;

let scene_move scene p = if (Objet.get_x p) > 550 then s2 else if (Objet.get_x p) < 50 then s else Scene.create (List.map (move scene) (Scene.get_objects scene)) (List.map (move scene) (Scene.get_characters scene)) (Scene.get_background scene);;

let keyboard_down e s o = 
				if e = Sdl.K.space then (Objet.set_vy (-12.) o)
				else if e = Sdl.K.up then (Objet.set_vy (-12.) o)
				else if e = Sdl.K.right then (Objet.set_vx 5 o)
				else if e = Sdl.K.left then (Objet.set_vx (-5) o)
				else o				
;;

let keyboard_up e o = 
				if e = Sdl.K.right then (Objet.set_vx 0 o)
				else if e = Sdl.K.left then (Objet.set_vx 0 o)
				else o
;;

let rec wait p s r w =
let scene = scene_move s p in
let move_pers = move s p in
let event = Sdl.Event.create () in
match Sdl.poll_event (Some(event)) with
| false -> Sdl.render_clear r; Scene.display_scene scene r; Tool.display_object [move_pers] r; Sdl.render_present r; wait move_pers scene r w
  | true -> match Sdl.Event.(enum (get event typ )) with
	        |`Quit -> Sdl.destroy_window w; Sdl.quit ()
			| `Key_down -> let pers = keyboard_down (Sdl.Event.(get event keyboard_keycode)) scene move_pers in wait pers scene r w
			| `Key_up -> let pers = keyboard_up (Sdl.Event.(get event keyboard_keycode)) move_pers in wait pers scene r w
            | _ -> Sdl.render_clear r;  Scene.display_scene s r; Tool.display_object [move_pers] r; Sdl.render_present r; wait move_pers scene r w
;;
  
let main () = match Sdl.init Sdl.Init.video with
  | Error (`Msg e) -> Sdl.log "Init error: %s" e; exit 1
  | Ok () -> match Sdl.create_window ~w:640 ~h:480 "Metroidvania" Sdl.Window.opengl with
	     | Error (`Msg e) -> Sdl.log "Create window error: %s" e; exit 1
	     | Ok w -> match Sdl.create_renderer ~flags:Sdl.Renderer.(accelerated + presentvsync) w with
	 	      | Error (`Msg e) ->  Sdl.log "Can't create renderer error: %s" e; exit 1
		      | Ok r -> wait personnage s r w
;; 

let () = main ();;

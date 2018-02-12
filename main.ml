open Tsdl
open Result
open Objet
open Tool
open Scene

(*eval $(opam config env)*)
(*ocamlbuild -use-ocamlfind -package tsdl,tsdl_mixer main.byte*)

let caisse = Objet.create 500 650 "caisse.bmp" 0. 0 120 80;;
let caisse2 = Objet.create 800 600 "caisse.bmp" 0. 0 120 80;;
let liste_objet = [ caisse; caisse2 ] ;;
let liste_objet2 = [ caisse2 ] ;;

let personnage = Objet.create 0 800 "char1.bmp" 0. 0 50 100 ;;

let liste_character = [] ;;

let s = Scene.create liste_objet liste_character "test.bmp" 1550 1033 ;;

let s2 = Scene.create liste_objet2 liste_character "test.bmp" 1550 1033 ;;

let c = Sdl.Rect.create 0 0 256 192;;

let move_camera c s move_pers = let c_x = Sdl.Rect.create (((Objet.get_x move_pers) + 50/2) - 640/2) (Sdl.Rect.y c) 256 192 in 
						if (Sdl.Rect.x c_x < 0) then 
							let c_y = Sdl.Rect.create 0 (((Objet.get_y move_pers)) - 480/2) 256 192 in 
								if Sdl.Rect.y c_y < 0 then c
									else if Sdl.Rect.y c_y > (Scene.get_height s) - 192 then (Sdl.Rect.create (Sdl.Rect.x c_y) ((Scene.get_height s) - 192) 256 192)
									 else c_y 
						else
							if Sdl.Rect.x c_x > (Scene.get_width s) - 256 then let c_x_y1 = Sdl.Rect.create ((Scene.get_width s) - 256) (((Objet.get_y move_pers)) -480/2) 256 192 in if Sdl.Rect.y c_x_y1 < 0 then Sdl.Rect.create (Sdl.Rect.x c_x_y1) 0 256 192
								else if Sdl.Rect.y c_x_y1 > (Scene.get_height s) - 192 then (Sdl.Rect.create (Sdl.Rect.x c_x_y1) ((Scene.get_height s) - 192) 256 192) 
									 else c_x_y1
													
							else
								let c_x_y2 = Sdl.Rect.create (Sdl.Rect.x c_x) (((Objet.get_y move_pers)) - 480/2 -50) 256 192 in 
									if Sdl.Rect.y c_x_y2 < 0 then Sdl.Rect.create (Sdl.Rect.x c_x_y2) 0 256 192
									else if Sdl.Rect.y c_x_y2 > (2000) - 192 then (Sdl.Rect.create (Sdl.Rect.x c_x_y2) ((Scene.get_height s) - 192) 256 192) 
										 else c_x_y2
;;

(* 0 : pas de collision, 1 : collision horizontale, 2: collision verticale*)
let rec collision sce o l = match l with 
						| [] -> false
						| x::s -> if (Objet.get_y o) > (Scene.get_height sce) then true
								  else if (Objet.get_x o) = (Objet.get_x x) && (Objet.get_y o) = (Objet.get_y x) then false
								  else 
								  let right1 = (Objet.get_x o) + (Objet.get_dx o) in 
								  let right2 = (Objet.get_x x) + (Objet.get_dx x) in
								  let bottom1 = (Objet.get_y o) + (Objet.get_dy o) in
								  let bottom2 = (Objet.get_y x) + (Objet.get_dy x) in
								  if bottom1 <= (Objet.get_y x) or (Objet.get_y o) >= bottom2 or right1 <= (Objet.get_x x) or (Objet.get_x o) >= right2 then (collision sce o s) else true
;;

let move s obj = let o_x = Objet.update_pos obj (Objet.get_x obj + Objet.get_vx obj) (Objet.get_y obj) in 
					if collision s o_x (Scene.get_objects s) or collision s o_x (Scene.get_characters s) then 
						let o_y = Objet.update_pos obj (Objet.get_x obj) ((Objet.get_y obj) + int_of_float(Objet.get_vy obj)) in 
							(if collision s o_y (Scene.get_objects s) or collision s o_y (Scene.get_characters s) then Objet.set_vy 0. obj 
							else o_y)
					else let o_x_y =  Objet.update_pos o_x (Objet.get_x o_x) ((Objet.get_y o_x) + int_of_float(Objet.get_vy o_x)) in 
						if collision s o_x_y (Scene.get_objects s) or collision s o_x_y (Scene.get_characters s) then Objet.set_vy 0. o_x else o_x_y ;;

let scene_move scene p = if (Objet.get_x p) > 2000 then s2 else if (Objet.get_x p) < 50 then s else Scene.create (List.map (move scene) (Scene.get_objects scene)) (List.map (move scene) (Scene.get_characters scene)) (Scene.get_background scene) 1550 1033 ;;

let keyboard_down e s o = 
				if e = Sdl.K.space then (Objet.set_vy (-12.) o)
				else if e = Sdl.K.up then (Objet.set_vy (-12.) o)
				else if e = Sdl.K.right then (Objet.set_vx 10 o)
				else if e = Sdl.K.left then (Objet.set_vx (-10) o)
				else o				
;;

let keyboard_up e o = 
				if e = Sdl.K.right then (Objet.set_vx 0 o)
				else if e = Sdl.K.left then (Objet.set_vx 0 o)
				else o
;;

let rec wait p s r w c =
let scene = scene_move s p in
let pers_temp = Objet.set_vy ((Objet.get_vy p) +. 0.5) p in 
let move_pers = (move s pers_temp) in
let cam = move_camera c s move_pers in
let event = Sdl.Event.create () in
match Sdl.poll_event (Some(event)) with
| false -> Sdl.render_clear r; Scene.display_scene scene r cam; Tool.display_object [move_pers] r cam; Sdl.render_present r; wait move_pers scene r w cam
  | true -> match Sdl.Event.(enum (get event typ )) with
	        |`Quit -> Sdl.destroy_window w; Sdl.quit ()
			| `Key_down -> let pers = keyboard_down (Sdl.Event.(get event keyboard_keycode)) scene move_pers in wait pers scene r w cam
			| `Key_up -> let pers = keyboard_up (Sdl.Event.(get event keyboard_keycode)) move_pers in wait pers scene r w cam
            | _ -> Sdl.render_clear r;  Scene.display_scene s r cam; Tool.display_object [move_pers] r cam; Sdl.render_present r; wait move_pers scene r w cam
;;
  
let main () = match Sdl.init Sdl.Init.video with
  | Error (`Msg e) -> Sdl.log "Init error: %s" e; exit 1
  | Ok () -> match Sdl.create_window ~w:640 ~h:480 "Metroidvania" Sdl.Window.opengl with
	     | Error (`Msg e) -> Sdl.log "Create window error: %s" e; exit 1
	     | Ok w -> match Sdl.create_renderer ~flags:Sdl.Renderer.(accelerated + presentvsync) w with
	 	      | Error (`Msg e) ->  Sdl.log "Can't create renderer error: %s" e; exit 1
		      | Ok r -> wait personnage s r w c
		      ;; 

let () = main ();;

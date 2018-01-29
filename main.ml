open Tsdl
open Result
open Objet
open Tool

(*eval $(opam config env)*)
(*ocamlbuild -use-ocamlfind -package tsdl,tsdl_mixer main.byte*)

let caisse = Objet.create 100 200 "caisse.bmp" 0. 0 120 80;;

let gravite obj = let o = Objet.update_pos obj (Objet.get_x obj + Objet.get_vx obj) ((Objet.get_y obj) + int_of_float(Objet.get_vy obj)) in if (Objet.get_y o) < 350 then Objet.set_vy ((Objet.get_vy o) +. 0.5) o else Objet.set_vy 0. o ;;

let keyboard_down e o = 
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

let rec wait o r w = 
let obj = gravite o in
let event = Sdl.Event.create () in
match Sdl.poll_event (Some(event)) with
  | false -> Sdl.render_clear r; Tool.display_background "test.bmp" r; Tool.display_object (Objet.get_x obj) (Objet.get_y obj) (Objet.get_image obj) r (Objet.get_dx obj) (Objet.get_dy obj); Tool.display_object (Objet.get_x caisse) (Objet.get_y caisse) (Objet.get_image caisse) r (Objet.get_dx caisse) (Objet.get_dy caisse); Sdl.render_present r; wait obj r w
  | true -> match Sdl.Event.(enum (get event typ )) with
	        |`Quit -> Sdl.destroy_window w; Sdl.quit ()
            |`Mouse_button_down -> let x = Sdl.Event.get event Sdl.Event.mouse_button_x in let y = Sdl.Event.get event Sdl.Event.mouse_button_y in let o = (Objet.update_pos obj x y) in wait o r w
			| `Key_down -> let o = keyboard_down (Sdl.Event.(get event keyboard_keycode)) obj in wait o r w
			| `Key_up -> let o = keyboard_up (Sdl.Event.(get event keyboard_keycode)) obj in wait o r w
            | _ -> Sdl.render_clear r; Tool.display_background "test.bmp" r; Tool.display_object (Objet.get_x obj) (Objet.get_y obj) (Objet.get_image obj) r (Objet.get_dx obj) (Objet.get_dy obj); Tool.display_object (Objet.get_x caisse) (Objet.get_y caisse) (Objet.get_image caisse) r (Objet.get_dx caisse) (Objet.get_dy caisse); Sdl.render_present r; wait obj r w
;;
  
let main () = match Sdl.init Sdl.Init.video with
  | Error (`Msg e) -> Sdl.log "Init error: %s" e; exit 1
  | Ok () -> match Sdl.create_window ~w:640 ~h:480 "Metroidvania" Sdl.Window.opengl with
	     | Error (`Msg e) -> Sdl.log "Create window error: %s" e; exit 1
	     | Ok w -> match Sdl.create_renderer ~flags:Sdl.Renderer.(accelerated + presentvsync) w with
	 	      | Error (`Msg e) ->  Sdl.log "Can't create renderer error: %s" e; exit 1
		      | Ok r -> wait (Objet.create 0 2 "char1.bmp" 0. 0 50 100) r w
;; 


let () = main ();;

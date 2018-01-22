open Tsdl
open Result
open Objet
open Tool

(*eval $(opam config env)*)
(*ocamlbuild -use-ocamlfind -package tsdl,tsdl_mixer metroidvania.byte*)

let o = Objet.create 0 2 "char1.bmp";;

let rec wait r w = Objet.update_pos o (Objet.get_x o) ((Objet.get_y o)+1)  ;
let event = Sdl.Event.create () in 
match Sdl.poll_event (Some(event)) with
  | false -> Sdl.render_clear r; Tool.display_background "test.bmp" r;Tool.display_object (Objet.get_x o) (Objet.get_y o) (Objet.get_image o) r; Sdl.render_present r; wait r w
  | true -> match Sdl.Event.(enum (get event typ)) with
	        |`Quit -> Sdl.destroy_window w; Sdl.quit ()
            |`Mouse_button_down -> let x = Sdl.Event.get event Sdl.Event.mouse_button_x in let y = Sdl.Event.get event Sdl.Event.mouse_button_y in (Objet.update_pos o x y); wait r w
            | _ -> Sdl.render_clear r; Tool.display_background "test.bmp" r;Tool.display_object (Objet.get_x o) (Objet.get_y o) (Objet.get_image o) r; Sdl.render_present r; wait r w
;;  
  
let main () = match Sdl.init Sdl.Init.video with
  | Error (`Msg e) -> Sdl.log "Init error: %s" e; exit 1
  | Ok () -> match Sdl.create_window ~w:640 ~h:480 "Metroidvania" Sdl.Window.opengl with
	     | Error (`Msg e) -> Sdl.log "Create window error: %s" e; exit 1
	     | Ok w -> match Sdl.create_renderer ~flags:Sdl.Renderer.(accelerated + presentvsync) w with
	 	      | Error (`Msg e) ->  Sdl.log "Can't create renderer error: %s" e; exit 1
		      | Ok r -> wait r w
;; 

let () = main ();;

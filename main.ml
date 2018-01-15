open Tsdl
open Result

(*ocamlbuild -use-ocamlfind -package tsdl,tsdl_mixer metroidvania.byte*)
 
let create_texture_from_surface r s = match Sdl.create_texture_from_surface r s with
|Error (`Msg e) -> Sdl.log "Can't create texture error: %s" e; exit 1
|Ok t -> t
;;

let print_image r i =  match Sdl.load_bmp i with
| Error (`Msg e) ->  Sdl.log "Cant load image  error: %s" e; exit 1
| Ok s -> match Sdl.render_copy r (create_texture_from_surface r s)  with
	  | Error (`Msg e) ->  Sdl.log "Can't fill image error: %s" e; exit 1 
	  | Ok () -> Sdl.render_present r
;;

let get_window_surface w = match Sdl.get_window_surface w with
| Error (`Msg e) -> Sdl.log "Can't get surface error: %s" e; exit 1
| Ok s -> s
;;

let rec wait w = 
let event = Sdl.Event.create () in 
match Sdl.wait_event (Some(event)) with
|Error (`Msg e) -> Sdl.log "Could not wait event: %s" e; exit 1
|Ok () -> match Sdl.Event.(enum (get event typ )) with
	  |`Quit -> Sdl.destroy_window w; Sdl.quit ()
	  | _ -> wait w 
;;
  
let main () = match Sdl.init Sdl.Init.video with
| Error (`Msg e) -> Sdl.log "Init error: %s" e; exit 1
| Ok () -> match Sdl.create_window ~w:640 ~h:480 "Metroidvania" Sdl.Window.opengl with
	   | Error (`Msg e) -> Sdl.log "Create window error: %s" e; exit 1
	   | Ok w -> match Sdl.create_renderer ~flags:Sdl.Renderer.(accelerated + presentvsync) w with
	 	    | Error (`Msg e) ->  Sdl.log "Can't create renderer error: %s" e; exit 1
		    | Ok r -> print_image r "test.bmp"; wait w
;;  

let () = main ()

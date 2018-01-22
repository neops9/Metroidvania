open Tsdl
open Result

let create_texture_from_surface r s = match (Sdl.create_texture_from_surface r s) with
| Error (`Msg e)  -> Sdl.log "Can't create texture error : %s" e; exit 1
| Ok t -> t
;;

let get_window_surface w = match (Sdl.get_window_surface w) with
| Error (`Msg e)  -> Sdl.log "Can't get surface error %s" e; exit 1
| Ok r -> r
;;

let display_object x y i r =  match Sdl.load_bmp i with
  | Error (`Msg e) ->  Sdl.log "Cant load image  error: %s" e; exit 1
  | Ok s -> let t = (create_texture_from_surface r s) in let rect = (Sdl.Rect.create x y 50 100) in match Sdl.render_copy ~dst:rect r t  with
	    | Error (`Msg e) ->  Sdl.log "Can't fill image error: %s" e; exit 1 
	    | Ok () -> Sdl.destroy_texture t
;;

let display_background i r =  match Sdl.load_bmp i with
  | Error (`Msg e) ->  Sdl.log "Cant load image  error: %s" e; exit 1
  | Ok s -> let t = (create_texture_from_surface r s) in match Sdl.render_copy r t  with
	    | Error (`Msg e) ->  Sdl.log "Can't fill image error: %s" e; exit 1 
	    | Ok () -> Sdl.destroy_texture t
;;

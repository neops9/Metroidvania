open Tsdl
open Result
open Objet

let create_texture_from_surface r s = match (Sdl.create_texture_from_surface r s) with
  | Error (`Msg e)  -> Sdl.log "Can't create texture error : %s" e; exit 1
  | Ok t -> t
;;

let create_texture_from_image r i = match Sdl.load_bmp i with
  | Error (`Msg e) ->  Sdl.log "Cant load image  error: %s" e; exit 1
  | Ok s -> create_texture_from_surface r s
;;

let get_window_surface w = match (Sdl.get_window_surface w) with
  | Error (`Msg e)  -> Sdl.log "Can't get surface error %s" e; exit 1
  | Ok r -> r
;;

let rec display_object l r c =  match l with 
  | [] -> ()
  | o::next ->
     let rect = (Sdl.Rect.create ((Objet.get_x o) - (Sdl.Rect.x c))  ((Objet.get_y o) - (Sdl.Rect.y c)) (Objet.get_dx o) (Objet.get_dy o)) in
     match Sdl.render_copy ~dst:rect r (Objet.get_texture o)  with
     | Error (`Msg e) ->  Sdl.log "Can't fill image error: %s" e; exit 1 
     | Ok () -> display_object next r c
;;

let objet_to_rect o = Sdl.Rect.create (Objet.get_x o) (Objet.get_y o) (Objet.get_dx o) (Objet.get_dy o) ;;

let display_background t r c =
  match Sdl.render_copy ~src:c r t  with
  | Error (`Msg e) ->  Sdl.log "Can't fill image error: %s" e; exit 1 
  | Ok () -> ()
;;

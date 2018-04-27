open Tsdl
open Sound

type button = { name : string; 
                texture : Sdl.texture; 
                x : int; 
                y :int; 
                dx : int; 
                dy : int; 
                sound : sound;
                is_selected : bool } ;;

let create name texture x y dx dy sound is_selected = { name; texture; x; y; dx; dy; sound; is_selected } ;;
let get_name b = b.name ;;
let get_texture b = b.texture ;;
let get_x b = b.x ;;
let get_y b = b.y ;;
let get_dx b = b.dx ;;
let get_dy b = b.dy ;;
let get_sound b = b.sound ;;
let is_selected b = b.is_selected ;;
let set_selected b v = { b with is_selected = v } ;;

let rec display r b =
  let rect = (Sdl.Rect.create b.x b.y b.dx b.dy) in
  match Sdl.render_copy ~dst:rect r b.texture  with
  | Error (`Msg e) ->  Sdl.log "Can't fill image error: %s" e; exit 1 
  | Ok () -> if is_selected b
             then
               let ligne = Sdl.Rect.create b.x (b.y + 73) b.dx 5 in
               match Sdl.set_render_draw_color r 249 143 51 0 with
               | Error (`Msg e) -> Sdl.log "Can't set render draw color: %s" e; exit 1
               | Ok () -> match Sdl.render_fill_rect r (Some ligne) with
                          | Error (`Msg e) -> Sdl.log "Can't fill rect: %s" e; exit 1
	                  | Ok () -> ()
;;

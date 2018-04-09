open Tsdl
open Tsdl_mixer
open Result
open Sound

type object = { x : int;
                y : int; 
                vy : float; 
                vx : int; 
                dx :int; 
                dy : int; 
                textures : Sdl.texture list;
                frame : Sdl.texture; 
                collision : bool; 
                flip : bool;
                life : int;
                life_time : int;
                sounds : sound list;
                has_moved : bool;
                is_projectile : bool }
;;

exception No_sound_found ;;
          
let create x y vy vx dx dy textures frame collision flip life life_time sounds is_projectile = { x; y; vy; vx; dx; dy; textures; frame; collision; flip; life; life_time; sounds; has_moved = false; is_projectile } ;;

let get_next_frame o = () ;;

let update o = { o with vy = o.vy +. 0.5; frame = get_next_frame o } ;;

let destroy o = List.iter (Sdl.destroy_texture) o.textures ;;

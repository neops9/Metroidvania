open Tsdl

type button = { name : string; texture : Sdl.texture; x : int; y :int; dx : int; dy : int; is_selected : bool } ;;

let create name texture x y dx dy is_selected = { name; texture; x; y; dx; dy; is_selected } ;;
let get_name b = b.name ;;
let get_texture b = b.texture ;;
let get_x b = b.x ;;
let get_y b = b.y ;;
let get_dx b = b.dx ;;
let get_dy b = b.dy ;;
let is_selected b = b.is_selected ;;
let set_selected b v = { b with is_selected = v } ;;

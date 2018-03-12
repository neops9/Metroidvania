open Tsdl
open Result

type objet = { x : int; y : int; vy : float; vx : int; dx :int; dy : int; frame : int; texture : Sdl.texture } ;;
let create x y texture vy vx dx dy frame = {x; y; vy; vx; dx; dy; frame; texture} ;;
let get_x o = o.x;;
let get_frame o = o.frame;;
let get_y o = o.y;;
let get_dx o = o.dx;;
let get_dy o = o.dy;;
let get_texture o = o.texture ;;
let get_vy o = o.vy ;;
let get_vx o = o.vx ;;
let set_frame o f = { o with frame = f } ;;
let set_texture o t = { o with texture = t } ;;
let set_vy o vy = { o with vy = vy } ;;
let set_vx o vx = { o with vx = vx } ;;
let update_pos o x y = { o with x = x; y = y } ;;

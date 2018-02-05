open Tsdl
open Result

type objet = { x : int; y : int; image : string; vy : float; vx : int; dx :int; dy : int };;
let create x y image vy vx dx dy = {x = x; y = y; image = image; vy = vy; vx = vx; dx = dx; dy = dy};;
let get_x o = o.x;;
let get_y o = o.y;;
let get_dx o = o.dx;;
let get_dy o = o.dy;;
let get_image o = o.image ;;
let get_vy o = o.vy ;;
let get_vx o = o.vx ;;
let set_vy vy o = create (get_x o) (get_y o) (get_image o) vy (get_vx o) (get_dx o) (get_dy o) ;; 
let set_vx vx o = create (get_x o) (get_y o) (get_image o) (get_vy o) vx (get_dx o) (get_dy o);; 
let update_pos o x y = create x y (get_image o) (get_vy o) (get_vx o) (get_dx o) (get_dy o) ;;

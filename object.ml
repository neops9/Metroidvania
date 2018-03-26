open Tsdl
open Result

type objet = { x : int; y : int; vy : float; vx : int; dx :int; dy : int; frame : int; texture : Sdl.texture; life_time : int; in_air : bool; flip : bool; collision : bool; character : bool } ;;
let create x y texture vy vx dx dy frame life_time in_air collision character = { x; y; vy; vx; dx; dy; frame; texture; life_time; in_air; flip = false; collision; character } ;;
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
let get_life_time o = o.life_time ;;
let set_life_time o lt = { o with life_time = lt } ;;
let is_in_air o = o.in_air ;;
let set_in_air o b = { o with in_air = b } ;;
let update o r = { o with vy = o.vy +. 0.5; texture = (Tool.create_texture_from_image r ("images/char"^((string_of_int) (o.frame / 5))^".bmp")) } ;; 
let objet_to_rect o = Sdl.Rect.create (get_x o) (get_y o) (get_dx o) (get_dy o) ;;
let is_flip o = o.flip ;;
let is_collision o = o.collision ;;
let is_character o = o.character ;;

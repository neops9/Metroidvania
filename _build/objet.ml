open Tsdl
open Result
open Tsdl_mixer
open Son

type objet = { x : int; y : int; vy : float; vx : int; dx :int; dy : int; frame : int; texture : Sdl.texture; life_time : int; in_air : bool; flip : bool; collision : bool; character : bool; bullet_time : int; life : int; sounds : son list} ;;
let create x y texture vy vx dx dy frame life_time in_air collision character life sounds = { x; y; vy; vx; dx; dy; frame; texture; life_time; in_air; flip = false; collision; character; bullet_time = 0; life; sounds } ;;
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
let objet_to_rect o = Sdl.Rect.create (get_x o) (get_y o) (get_dx o) (get_dy o) ;;
let is_flip o = o.flip ;;
let is_collision o = o.collision ;;
let is_character o = o.character ;;
let get_bullet_time o = o.bullet_time ;;
let get_life o = o.life ;;

exception No_sound_found ;;

let get_sound o s =
  let rec get_sound_rec l s =
    match l with
    | [] -> raise No_sound_found
    | m::next -> if (Son.get_nom m) = s then (Son.get_music) m else get_sound_rec next s
  in
  get_sound_rec o.sounds s
;;

let update o r = if get_y o > 1000 then { o with x = 10 ; y = 840 ; life = (get_life o) - 1} else if is_in_air o then { o with vy = o.vy +. 0.5; texture = (Tool.create_texture_from_image r "images/char3.bmp"); bullet_time = o.bullet_time - 1 } else { o with vy = o.vy +. 0.5; texture = (Tool.create_texture_from_image r ("images/char"^((string_of_int) (o.frame / 5))^".bmp")); bullet_time = o.bullet_time - 1 } ;; 

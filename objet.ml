open Tsdl
open Result
open Tsdl_mixer
open Sound

type objet = { x : int; y : int; vy : float; vx : int; dx :int; dy : int; frame : int; texture : Sdl.texture; life_time : int; in_air : bool; flip : bool; collision : bool; character : bool; bullet_time : int; life : int; sounds : sound list; is_bullet : bool; invulnerable : int; has_moved : bool } ;;
let create x y texture vy vx dx dy frame life_time in_air collision character life sounds is_bullet = { x; y; vy; vx; dx; dy; frame; texture; life_time; in_air; flip = false; collision; character; bullet_time = 0; life; sounds; is_bullet; invulnerable = 0; has_moved = true } ;;
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
let is_bullet o = o.is_bullet ;;
let get_invulnerable o = o.invulnerable ;;
let has_moved o = o.has_moved ;;

exception No_sound_found ;;

let get_sound o s =
  let rec get_sound_rec l s =
    match l with
    | [] -> raise No_sound_found
    | m::next -> if (Sound.get_name m) = s then m else get_sound_rec next s
  in
  get_sound_rec o.sounds s
;;

let update o r = if get_y o > 1000 then begin play_sound (get_sound o "lose"); { o with x = 10 ; y = 840 ; life = (get_life o) - 1 ; invulnerable = 0} end else if is_in_air o then { o with vy = (get_vy o) +. 0.5 ; texture = (Tool.create_texture_from_image r "images/char3.bmp"); bullet_time = o.bullet_time - 1; invulnerable = o.invulnerable - 10 } else { o with vy = o.vy +. 0.5; texture = (Tool.create_texture_from_image r ("images/char"^((string_of_int) (o.frame / 5))^".bmp")); bullet_time = o.bullet_time - 1; invulnerable = o.invulnerable - 10 } ;;

let equals o1 o2 = if get_x o1 = get_x o2 && get_dx o1 = get_dx o2 && get_dy o1 = get_dy o2 && is_in_air o1 = is_in_air o2 && is_flip o1 = is_flip o2 && is_character o1 = is_character o2 then true else false
;; 

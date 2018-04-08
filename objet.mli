open Tsdl
open Result
open Son
open Tsdl_mixer

type objet = { x : int; 
	       y : int; 
	       vy : float; 
	       vx : int; 
	       dx :int; 
	       dy : int; 
	       frame : int; 
	       texture : Sdl.texture; 
	       life_time : int; 
	       in_air : bool;
	       flip : bool;
	       collision : bool;
	       character : bool;
	       bullet_time : int;
	       life : int;
	       sounds : son list } ;;

val create : int -> int -> Sdl.texture -> float -> int -> int -> int-> int ->  int -> bool -> bool -> bool -> int -> son list -> objet
val get_x : objet -> int
val get_frame : objet -> int
val get_dx : objet -> int
val get_dy : objet -> int
val get_y : objet -> int
val get_vy : objet -> float
val set_vy : objet -> float -> objet
val get_vx : objet -> int
val set_vx : objet -> int -> objet
val get_sound : objet -> string -> Mixer.chunk
val update_pos : objet -> int -> int -> objet
val set_frame : objet -> int -> objet
val get_texture : objet -> Sdl.texture
val get_life_time : objet -> int
val set_life_time : objet -> int -> objet
val set_texture : objet -> Sdl.texture -> objet
val set_in_air : objet -> bool -> objet
val is_in_air : objet -> bool
val update : objet -> Sdl.renderer -> objet
val objet_to_rect : objet -> Sdl.rect
val is_flip : objet -> bool
val is_collision : objet -> bool
val is_character : objet -> bool
val get_bullet_time : objet -> int
val get_life : objet -> int

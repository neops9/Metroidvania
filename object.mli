open Tsdl
open Result

type objet

val create : int -> int -> Sdl.texture -> float -> int -> int -> int-> int ->  int -> objet
val get_x : objet -> int
val get_frame : objet -> int
val get_dx : objet -> int
val get_dy : objet -> int
val get_y : objet -> int
val get_vy : objet -> float
val set_vy : objet -> float -> objet
val get_vx : objet -> int
val set_vx : objet -> int -> objet
val update_pos : objet -> int -> int -> objet
val set_frame : objet -> int -> objet
val get_texture : objet -> Sdl.texture
val get_life_time : objet -> int
val set_life_time : objet -> int -> objet
val set_texture : objet -> Sdl.texture -> objet

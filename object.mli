open Tsdl
open Result

type objet
val create : int -> int -> string -> float -> int -> int -> int-> objet
val get_x : objet -> int
val get_dx : objet -> int
val get_dy : objet -> int
val get_y : objet -> int
val get_vy : objet -> float
val set_vy : float -> objet -> objet
val get_vx : objet -> int
val set_vx : int -> objet -> objet
val update_pos : objet -> int -> int -> objet
val get_image : objet -> string

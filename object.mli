open Tsdl
open Result


type objet
val create : int -> int -> string -> objet
val get_x : objet -> int
val get_y : objet -> int
val update_pos : objet -> int -> int -> unit
val get_image : objet -> string

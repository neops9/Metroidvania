open Tsdl
   
type bouton

val create : string -> Sdl.texture -> int -> int -> int -> int -> bouton
val get_nom : bouton -> string
val get_texture : bouton -> Sdl.texture
val get_x : bouton -> int
val get_y : bouton -> int
val get_dx : bouton -> int
val get_dy : bouton -> int
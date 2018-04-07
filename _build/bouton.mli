open Tsdl
   
type bouton = { nom : string; texture : Sdl.texture; x : int; y :int; dx : int; dy : int; est_bouton_courant : bool } ;;

val create : string -> Sdl.texture -> int -> int -> int -> int -> bool -> bouton
val get_nom : bouton -> string
val get_texture : bouton -> Sdl.texture
val get_x : bouton -> int
val get_y : bouton -> int
val get_dx : bouton -> int
val get_dy : bouton -> int
val est_courant : bouton -> bool
val set_courant : bouton -> bool -> bouton

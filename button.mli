open Tsdl
open Sound
   
type button

val create : string -> Sdl.texture -> int -> int -> int -> int -> sound -> bool -> button
val get_name : button -> string
val get_texture : button -> Sdl.texture
val get_x : button -> int
val get_y : button -> int
val get_dx : button -> int
val get_dy : button -> int
val get_sound : button -> sound
val is_selected : button -> bool
val set_selected : button -> bool -> button
val display : Sdl.renderer -> button -> unit

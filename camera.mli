open Tsdl
open Player

type camera

val create : Sdl.rect -> int -> int -> camera
val get_rect : camera -> Sdl.rect
val move : camera -> player -> int -> int -> unit

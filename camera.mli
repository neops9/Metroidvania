open Scene
open Objet
open Tsdl

type camera

val create : Sdl.rect -> int -> int -> camera
val get_rect : camera -> Sdl.rect
val move : camera -> scene -> objet -> unit

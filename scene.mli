open Tsdl
open Result
open Objet

type scene
val create : Objet.objet list -> Objet.objet list -> string -> int -> int -> scene
val get_characters : scene -> Objet.objet list
val get_objects : scene -> Objet.objet list
val get_background : scene -> string
val display_scene : scene -> Sdl.renderer -> Sdl.rect -> unit
val get_width : scene -> int
val get_height : scene -> int

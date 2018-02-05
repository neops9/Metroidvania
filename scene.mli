open Tsdl
open Result
open Objet

type scene
val create : Objet.objet list -> Objet.objet list -> string -> scene
val get_characters : scene -> Objet.objet list
val get_objects : scene -> Objet.objet list
val get_background : scene -> string
val display_scene : scene -> Sdl.renderer -> unit

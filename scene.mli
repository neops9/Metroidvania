open Tsdl
open Result
open Objet

type scene = { object_list : Objet.objet list ;
	       character_list : Objet.objet list ;
	       texture_list : Sdl.texture list ;
	       background : Sdl.texture ;
	       width : int ;
	       height : int}
  
val create : Sdl.renderer -> Objet.objet list -> Objet.objet list -> Sdl.texture list -> string -> int -> int -> scene
val get_characters : scene -> Objet.objet list
val get_objects : scene -> Objet.objet list
val get_background : scene -> Sdl.texture
val display_scene : scene -> Sdl.renderer -> Sdl.rect -> unit
val get_width : scene -> int
val get_height : scene -> int
val load_scene : string -> Sdl.renderer -> int -> scene


open Tsdl
open Result
open Objet

type scene = { player : objet; 
		   object_list : Objet.objet list ;
	       character_list : Objet.objet list ;
	       texture_list : Sdl.texture list ;
	       background : Sdl.texture ;
	       width : int ;
	       height : int}
  
val create : Sdl.renderer -> Objet.objet -> Objet.objet list -> Objet.objet list -> Sdl.texture list -> string -> int -> int -> scene
val get_characters : scene -> Objet.objet list
val get_objects : scene -> Objet.objet list
val get_background : scene -> Sdl.texture
val get_width : scene -> int
val get_height : scene -> int
val get_player : scene -> objet
val load_scene : objet -> string -> Sdl.renderer -> int -> scene

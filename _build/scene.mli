open Tsdl
open Result
open Objet
open Music
open Unit

type scene = { renderer : Sdl.renderer;
               width : int;
	           height : int;
	           background : Sdl.texture;
	           music : music;
			   player : unit; 
		       gameobjects : objet list ;
	           units : unit list ;
	           items : objet list ;
               next_scene : string;
               prev_scene : string } 
  
val create : Sdl.renderer -> unit -> objet list -> unit list -> string -> int -> int -> string -> string -> music -> scene
val load_scene : unit -> string -> Sdl.renderer -> int -> music -> scene
val change_scene : scene -> string -> int -> scene
val destroy_scene : scene -> unit

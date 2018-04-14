open Tsdl
open Result
open Gameobject
open Character
open Music
open Player

type scene = { renderer : Sdl.renderer;
               width : int;
	           height : int;
	           background : Sdl.texture;
	           music : music;
			   player : player; 
		       gameobjects : gameobject list ;
	           characters : character list ;
	           items : gameobject list ;
               next_scene : string;
               prev_scene : string } 
;;
  
val create : Sdl.renderer -> player -> gameobject list -> character list -> gameobject list ->string -> int -> int -> string -> string -> music -> scene
val load : player -> string -> Sdl.renderer -> int -> music -> scene
val get_renderer : scene -> Sdl.renderer
val get_player : scene -> player
val get_width : scene -> int
val get_height : scene -> int
val display : scene -> Sdl.rect -> unit
val update : scene -> scene
val move : scene -> scene
val change_scene : scene -> string -> int -> scene
val destroy : scene -> unit
val set_player : scene -> player -> scene

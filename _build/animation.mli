open Tsdl

type animation = { name : string;
		   dx : int;
                   dy : int; 
                   current_frames : Sdl.texture list; 
                   frames : Sdl.texture list;
                   step : int;
                   timer : int;
                   loop : int }

val create : string -> int -> int -> Sdl.texture list -> int -> int -> animation
val get_dx : animation -> int
val get_dy : animation -> int
val get_texture : animation -> Sdl.texture
val update : animation -> animation
val destroy : animation -> unit
val get_name : animation -> string

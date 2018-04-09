open Tsdl
open Tsdl_mixer
open Result
open Sound

type object = { x : int;
                y : int; 
                vy : float; 
                vx : int; 
                dx :int; 
                dy : int; 
                textures : Sdl.texture list;
                frame : Sdl.texture; 
                collision : bool; 
                flip : bool;
                life : int;
                life_time : int;
                sounds : sound list;
                has_moved : bool;
                is_projectile : bool }

val create : int -> int -> float -> int -> int -> int -> Sdl.texture list -> Sdl.texture -> bool -> bool -> int -> int -> sound list -> bool -> object
val get_next_frame : object -> Sdl.texture
val update : object -> object
val destroy ; object -> unit

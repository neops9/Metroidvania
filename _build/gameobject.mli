open Tsdl
open Tsdl_mixer
open Result
open Sound
open Animation

type gameobject = { name : string;
		    x : int;
                    y : int; 
                    vx : int; 
                    vy : float; 
                    current_animation : animation;
                    animations : animation list; 
                    collision : bool; 
                    flip : bool;
                    life : int;
                    life_time : int;
                    sounds : sound list;
                    projectiles : gameobject list;
                    is_projectile : bool }
;;

val create : string -> int -> int -> int -> float -> animation -> animation list -> bool -> bool -> int -> int -> sound list -> bool -> gameobject
val get_x : gameobject -> int
val get_y : gameobject -> int
val get_current_animation : gameobject -> animation
val get_life_time : gameobject -> int
val get_dx : gameobject -> int
val get_dy : gameobject -> int
val get_vx : gameobject -> int
val get_vy : gameobject -> float
val get_texture : gameobject -> Sdl.texture
val update : gameobject -> gameobject
val display : Sdl.renderer -> Sdl.rect -> gameobject -> unit
val move : Sdl.rect list -> gameobject -> gameobject
val destroy : gameobject -> unit
val gameobject_to_rect : gameobject -> Sdl.rect
val is_collision : gameobject -> bool
val get_projectiles : gameobject -> gameobject list

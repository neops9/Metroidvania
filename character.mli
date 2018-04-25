open Tsdl
open Tsdl_mixer
open Result
open Sound
open Animation
open Gameobject

type character = { name : string;
                   x : int; 
                   y : int; 
                   vx : int; 
                   vy : float; 
                   current_animation : animation;
                   animations : animation list;
                   sounds : sound list;
                   projectile : animation;
                   projectiles : gameobject list;
                   flip : bool;
                   life : int;
                   collision : bool;
                   reload_time : int; 
                   invulnerable_time : int; 
                   in_air : bool;
                   has_moved : bool }

val create : string -> int -> int -> int -> float -> animation -> animation list -> sound list -> animation -> bool -> int -> character
val get_x : character -> int
val get_y : character -> int
val get_vx : character -> int
val get_vy : character -> float
val get_dx : character -> int
val get_dy : character -> int
val get_current_animation : character -> animation
val get_texture : character -> Sdl.texture
val get_projectiles : character -> gameobject list
val update : character -> character
val display : Sdl.renderer -> Sdl.rect -> character -> unit
val move : Sdl.rect list -> character -> character
val play_action : character -> character
val destroy : character -> unit
val character_to_rect : character -> Sdl.rect
val is_collision : character -> bool
val get_name : character -> string

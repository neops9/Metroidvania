open Tsdl
open Tsdl_mixer
open Result
open Sound
open Animation
open Gameobject
open Character

type player = { name : string;
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
                has_moved : bool;
                heart_texture : Sdl.texture;
                damaged_characters : character list }
;;

val create : string -> int -> int -> int -> float -> animation -> animation list -> sound list -> animation -> bool -> int -> Sdl.texture -> player
val get_life : player -> int
val get_x : player -> int
val get_y : player -> int
val get_dx : player -> int
val get_dy : player -> int
val get_vy : player -> float
val get_sounds : player -> sound list
val get_texture : player -> Sdl.texture
val is_in_air : player -> bool
val update : player -> player
val display : Sdl.renderer -> Sdl.rect -> player -> unit
val move : Sdl.rect list -> character list -> player -> player
val destroy : player -> unit
val get_current_animation : player -> animation
val player_to_rect : player -> Sdl.rect
val get_projectiles : player -> gameobject list
val get_invulnerable_time : player -> int

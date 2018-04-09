open Tsdl
open Tsdl_mixer
open Result
open Sound

type unit = { x : int; 
              y : int; 
              vy : float; 
              vx : int; 
              dx :int; 
              dy : int; 
              frame : Sdl.texture; 
              textures : Sdl.texture list; 
              sounds : sound list;
              flip : bool; 
              life : int;
              reload_time : int; 
              invulnerable_time : int; 
              has_moved : bool }
;;

open Tsdl
open Result

val display_object : int -> int -> string -> Sdl.renderer -> int -> int -> unit
val display_background : string -> Sdl.renderer -> unit
val create_texture_from_surface : Sdl.renderer -> Sdl.surface -> Sdl.texture
val get_window_surface : Sdl.window -> Sdl.surface

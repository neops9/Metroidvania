open Tsdl
open Result

val create_texture_from_image : Sdl.renderer -> string -> Sdl.texture
val create_texture_from_surface : Sdl.renderer -> Sdl.surface -> Sdl.texture
val get_window_surface : Sdl.window -> Sdl.surface
val scancode : string -> Sdl.scancode

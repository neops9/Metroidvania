open Tsdl
open Result
open Tsdl_mixer

val create_texture_from_image : Sdl.renderer -> string -> Sdl.texture
val create_texture_from_surface : Sdl.renderer -> Sdl.surface -> Sdl.texture
val create_surface_from_image : string -> Sdl.surface
val get_window_surface : Sdl.window -> Sdl.surface
val scancode : string -> Sdl.scancode
val load_chunk : string -> Mixer.chunk

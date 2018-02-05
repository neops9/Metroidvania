open Tsdl
open Result
open Objet

val display_object : Objet.objet list -> Sdl.renderer -> unit
val display_background : string -> Sdl.renderer -> unit
val create_texture_from_surface : Sdl.renderer -> Sdl.surface -> Sdl.texture
val get_window_surface : Sdl.window -> Sdl.surface

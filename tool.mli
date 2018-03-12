open Tsdl
open Result
open Objet

val display_object : Objet.objet list -> Sdl.renderer -> Sdl.rect -> unit
val display_background : Sdl.texture -> Sdl.renderer -> Sdl.rect -> unit
val create_texture_from_image : Sdl.renderer -> string -> Sdl.texture
val create_texture_from_surface : Sdl.renderer -> Sdl.surface -> Sdl.texture
val get_window_surface : Sdl.window -> Sdl.surface
val objet_to_rect : Objet.objet -> Sdl.rect

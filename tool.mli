open Tsdl
open Result
open Tsdl_mixer

val create_texture_from_image : Sdl.renderer -> string -> Sdl.texture
val create_texture_from_surface : Sdl.renderer -> Sdl.surface -> Sdl.texture
val create_surface_from_image : string -> Sdl.surface
val get_window_surface : Sdl.window -> Sdl.surface
val scancode : string -> Sdl.scancode
val load_chunk : string -> Mixer.chunk
val load_music : string -> Mixer.music
val object_to_rect : objet -> Sdl.rect
val unit_to_rect : unit -> Sdl.rect
val get_sound_from_list : sound list -> string -> sound

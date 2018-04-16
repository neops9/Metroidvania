open Tsdl
open Tsdl_mixer
open Result
open Sound
open Animation

exception No_sound_found
exception No_animation_found

val create_texture_from_image : Sdl.renderer -> string -> Sdl.texture
val create_texture_from_surface : Sdl.renderer -> Sdl.surface -> Sdl.texture
val create_surface_from_image : string -> Sdl.surface
val get_window_surface : Sdl.window -> Sdl.surface
val scancode : string -> Sdl.scancode
val load_chunk : string -> Mixer.chunk
val load_music : string -> Mixer.music
val get_sound_from_list : sound list -> string -> sound
val get_animation_from_list : animation list -> string -> animation
val collision : Sdl.rect -> Sdl.rect -> bool
val collision_rec : Sdl.rect -> Sdl.rect list -> bool

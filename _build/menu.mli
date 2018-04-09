open Tsdl
open Button
open Tsdl_mixer
open Music
open Sound
   
type menu

val create : Sdl.renderer -> Sdl.texture -> button list -> music -> sound -> menu
val get_button_list : menu -> button list
val get_bg : menu -> Sdl.texture
val load_menu : Sdl.renderer -> menu
val destroy_menu : menu -> unit
val update_buttons : menu -> menu
val get_action : menu -> string
val get_music : menu -> music
val get_button_sound : menu -> sound
val get_renderer : menu -> Sdl.renderer

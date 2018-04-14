open Tsdl
open Button
open Tsdl_mixer
open Music
   
type menu

val create : Sdl.renderer -> Sdl.texture -> button list -> music -> menu
val load : Sdl.renderer -> menu
val get_renderer : menu -> Sdl.renderer
val destroy : menu -> unit
val display : menu -> unit
val update_buttons : menu -> menu
val get_action : menu -> string
val get_selected_button : menu -> button
val get_bg : menu -> Sdl.texture

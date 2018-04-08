open Tsdl
open Bouton
open Tsdl_mixer
open Son
   
type menu

val create : Sdl.texture -> bouton list -> Mixer.music -> son -> menu
val get_bouton_list : menu -> bouton list
val get_bg : menu -> Sdl.texture
val load_menu : Sdl.renderer -> menu
val destroy_menu : menu -> unit
val update_boutons : menu -> menu
val get_action : menu -> string
val get_music : menu -> Mixer.music
val get_son : menu -> Mixer.chunk

open Tsdl
open Bouton
   
type menu

val create : Sdl.texture -> bouton list -> menu
val get_bouton_list : menu -> bouton list
val get_bg : menu -> Sdl.texture
val load_menu : Sdl.renderer -> menu
val destroy_menu : menu -> unit

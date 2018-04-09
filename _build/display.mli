open Tsdl
open Objet
open Scene
open Camera
open Button
open Menu

val display_background : Sdl.texture -> Sdl.renderer -> Sdl.rect -> unit
val display_object : Sdl.renderer -> Sdl.rect -> objet -> unit
val display_user_interface : Sdl.renderer -> Sdl.rect -> objet -> unit
val display_scene : scene -> Sdl.renderer -> Sdl.rect -> unit
val display_buttons : button list -> Sdl.renderer -> unit
val display_menu : menu -> unit
val display_game : scene -> Sdl.renderer -> camera -> unit

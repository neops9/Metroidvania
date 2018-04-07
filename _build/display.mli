open Tsdl
open Objet
open Scene
open Camera
open Bouton
open Menu

val display_background : Sdl.texture -> Sdl.renderer -> Sdl.rect -> unit
val display_object : objet list -> Sdl.renderer -> Sdl.rect -> unit
val display_personnage : objet -> Sdl.renderer -> Sdl.rect -> unit
val display_scene : scene -> Sdl.renderer -> Sdl.rect -> unit
val display_boutons : bouton list -> Sdl.renderer -> unit
val display_menu : menu -> Sdl.renderer -> unit
val display_game : objet -> scene -> Sdl.renderer -> camera -> unit

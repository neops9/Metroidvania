open Tsdl
open Objet
open Scene
open Camera

val display_background : Sdl.texture -> Sdl.renderer -> Sdl.rect -> unit
val display_object : objet list -> Sdl.renderer -> Sdl.rect -> unit
val display_personnage : objet -> Sdl.renderer -> Sdl.rect -> unit
val display_scene : scene -> Sdl.renderer -> Sdl.rect -> unit
val display_game : objet -> scene -> Sdl.renderer -> camera -> unit

open Tsdl
open Objet
open Scene

val collision : scene -> objet -> objet list -> bool
val move_object : scene -> objet -> objet
val move_scene : scene -> objet -> scene

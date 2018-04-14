open Tsdl
open Menu
open Scene
open Camera

type game

val create : Sdl.window -> Sdl.renderer -> menu -> game
val get_menu : game -> menu
val get_window : game -> Sdl.window
val get_renderer : game -> Sdl.renderer
val launch_game : game -> unit
val quit : game -> unit

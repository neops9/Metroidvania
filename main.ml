open Tsdl
open Tsdl_mixer
open Menu
open Game
open Tool

let window_width = 1024;;
let window_height = 768;;

let main () = match Sdl.init Sdl.Init.(video + audio) with
  | Error (`Msg e) -> Sdl.log "Init error: %s" e; exit 1
  | Ok () -> match Sdl.create_window ~w:window_width ~h:window_height "Raccoon's Adventure" Sdl.Window.opengl with
             | Error (`Msg e) -> Sdl.log "Create window error: %s" e; exit 1
             | Ok w -> Sdl.set_window_icon w (Tool.create_surface_from_image "images/Objects/mushroom1.bmp");
		       match Sdl.create_renderer ~flags:Sdl.Renderer.(accelerated + presentvsync) w with
                       | Error (`Msg e) ->  Sdl.log "Can't create renderer error: %s" e; exit 1
                       | Ok r -> match Mixer.open_audio 44100 Sdl.Audio.s16_sys 2 2048 with
				 | Error (`Msg e) -> Sdl.log "Can't open audio: %s" e; exit 1
				 | Ok () -> let menu = Menu.load r in
					    let game = Game.create w r menu in
					    launch_game game

let () = main () ;;

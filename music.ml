open Tsdl
open Tsdl_mixer

type music = { name : string; music : Mixer.music } ;;

let create name music = { name; music } ;;
let get_name m = m.name ;;
let get_music m = m.music ;;

let play_music m = 
  match Mixer.play_music (m.music) (-1) with
  | Error (`Msg e) ->  Sdl.log "Can't play music error: %s" e; exit 1
  | Ok n -> ()
;;

let free_music m = Mixer.free_music (m.music) ;

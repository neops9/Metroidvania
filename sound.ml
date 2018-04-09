open Tsdl
open Tsdl_mixer

type sound = { name : string; sound : Mixer.chunk } ;;

let create name sound = { name; sound } ;;
let get_name m = m.name ;;
let get_sound m = m.sound ;;
let play_sound s = 
  match Mixer.play_channel (-1) (s.sound) 0 with 
  | Error (`Msg e) ->  Sdl.log "Can't play sound error: %s" e; exit 1
  | Ok n -> ()
;;

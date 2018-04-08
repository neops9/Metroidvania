open Tsdl
open Tsdl_mixer

type sound = { nom : string; son : Mixer.chunk }

let create nom son = { nom; son } ;;
let get_nom s = s.nom ;;
let get_music s = s.son ;;

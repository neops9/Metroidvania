open Tsdl
open Tsdl_mixer

type son = { nom : string; son_chunk : Mixer.chunk } ;;

let create nom son_chunk = {nom; son_chunk } ;;
let get_nom s = s.nom ;;
let get_music s = s.son_chunk ;;

open Tsdl

type bouton = { nom : string; texture : Sdl.texture; x : int; y :int; dx : int; dy : int } ;;

let create nom texture x y dx dy = { nom; texture; x; y; dx; dy } ;;
let get_nom b = b.nom ;;
let get_texture b = b.texture ;;
let get_x b = b.x ;;
let get_y b = b.y ;;
let get_dx b = b.dx ;;
let get_dy b = b.dy ;;


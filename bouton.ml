open Tsdl

type bouton = { nom : string; texture : Sdl.texture; x : int; y :int; dx : int; dy : int; est_bouton_courant : bool } ;;

let create nom texture x y dx dy est_bouton_courant = { nom; texture; x; y; dx; dy; est_bouton_courant } ;;
let get_nom b = b.nom ;;
let get_texture b = b.texture ;;
let get_x b = b.x ;;
let get_y b = b.y ;;
let get_dx b = b.dx ;;
let get_dy b = b.dy ;;
let est_courant b = b.est_bouton_courant ;;
let set_courant b v = { b with est_bouton_courant = v } ;;

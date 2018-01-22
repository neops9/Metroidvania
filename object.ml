open Tsdl
open Result

type objet = { mutable x : int; mutable y : int; image : string};;
let create x y image = {x = x; y = y; image = image};;
let get_x o = o.x;;
let get_y o = o.y;;
let get_image o = o.image ;;
let update_pos o x y = o.x <- x; o.y <- y;;

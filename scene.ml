open Tsdl
open Result
open Objet

type scene = { object_list : Objet.objet list ;
	       character_list : Objet.objet list ;
	       background : Sdl.texture ;
	       width : int ;
	       height : int } ;;

let create r l1 l2 background w h =
  let t = match Sdl.load_bmp background with
    | Error (`Msg e) ->  Sdl.log "Cant load image  error: %s" e; exit 1
    | Ok s ->
       match Sdl.create_texture_from_surface r s with
       | Error (`Msg e) -> Sdl.log "Cant create texture  error: %s" e; exit 1
       | Ok t -> t
  in { object_list = l1 ;
       character_list = l2 ;
       background = t ;
       width = w ;
       height = h } ;;

let get_characters s = s.character_list ;;
let get_objects s = s.object_list ;;
let get_background s = s.background ;;
let display_scene s r c = Tool.display_background s.background r c ; Tool.display_object (s.object_list) r c; Tool.display_object (s.character_list) r c;;
let get_width s = s.width ;;
let get_height s = s.height ;;

open Tsdl
open Result
open Objet

type scene = { object_list : Objet.objet list ; character_list : Objet.objet list ; background : string } ;;
let create l1 l2 background = { object_list = l1 ; character_list = l2 ; background = background} ;;
let get_characters s = s.character_list ;;
let get_objects s = s.object_list ;;
let get_background s = s.background ;;
let display_scene s r = Tool.display_background s.background r ; Tool.display_object (s.object_list) r ; Tool.display_object (s.character_list) r ;;

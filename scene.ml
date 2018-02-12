open Tsdl
open Result
open Objet

type scene = { object_list : Objet.objet list ; character_list : Objet.objet list ; background : string ; width : int ; height : int} ;;
let create l1 l2 background w h = { object_list = l1 ; character_list = l2 ; background = background ; width = w ; height = h } ;;
let get_characters s = s.character_list ;;
let get_objects s = s.object_list ;;
let get_background s = s.background ;;
let display_scene s r c = Tool.display_background s.background r c ; Tool.display_object (s.object_list) r c; Tool.display_object (s.character_list) r c;;
let get_width s = s.width ;;
let get_height s = s.height ;;

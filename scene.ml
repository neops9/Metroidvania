open Tsdl
open Result
open Objet

type scene = { object_list : Objet.objet list ;
	       character_list : Objet.objet list ;
	       texture_list : Sdl.texture list ;
	       background : Sdl.texture ;
	       width : int ;
	       height : int } ;;

let create r l1 l2 tl background w h =
  let t = match Sdl.load_bmp background with
    | Error (`Msg e) ->  Sdl.log "Cant load image  error: %s" e; exit 1
    | Ok s ->
       match Sdl.create_texture_from_surface r s with
       | Error (`Msg e) -> Sdl.log "Cant create texture  error: %s" e; exit 1
       | Ok t -> t
  in { object_list = l1 ;
       character_list = l2 ;
       texture_list = tl ;
       background = t ;
       width = w ;
       height = h } 
;;
      
let load_scene file r h =
  let f = open_in file in
  let bg = input_line f in
  let texture_list = String.split_on_char ';' (input_line f) in
  let textures = Array.of_list (List.rev (List.fold_left (fun acc x -> let t = Tool.create_texture_from_image r x in t::acc) [] texture_list)) in
  let objects = ref [] in
  let characters = ref [] in
  try
    while true; 
    do
      let line = Array.of_list (String.split_on_char ';' (input_line f)) in
      if line.(0) = "c"
      then
	    characters := (Objet.create (int_of_string line.(2)) (int_of_string line.(3)) textures.(int_of_string line.(1)) 0. 0 (int_of_string line.(4)) (int_of_string line.(5)) 0 100000000)::!characters
      else
		objects := (Objet.create (int_of_string line.(2)) ((int_of_string line.(3)) + h) textures.(int_of_string line.(1)) 0. 0 (int_of_string line.(4)) (int_of_string line.(5)) 0 100000000)::!objects
    done; create r !objects !characters (Array.to_list textures) bg 1280 960
  with End_of_file -> close_in f; create r !objects !characters (Array.to_list textures) bg 1280 960
;;
      
let get_characters s = s.character_list ;;
let get_objects s = s.object_list ;;
let get_background s = s.background ;;
let display_scene s r c = Tool.display_background s.background r c ; Tool.display_object (s.object_list) r c; Tool.display_object (s.character_list) r c;;
let get_width s = s.width ;;
let get_height s = s.height ;;

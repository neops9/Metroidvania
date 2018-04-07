open Tsdl
open Result
open Objet

type scene = { player : objet; 
		   object_list : Objet.objet list ;
	       character_list : Objet.objet list ;
	       texture_list : Sdl.texture list ;
	       background : Sdl.texture ;
	       width : int ;
	       height : int ;
               renderer : Sdl.renderer;
               next_scene : string;
               prev_scene : string } ;;

let create r p l1 l2 tl background w h next_scene prev_scene =
  let t = match Sdl.load_bmp background with
    | Error (`Msg e) ->  Sdl.log "Cant load image  error: %s" e; exit 1
    | Ok s ->
       match Sdl.create_texture_from_surface r s with
       | Error (`Msg e) -> Sdl.log "Cant create texture  error: %s" e; exit 1
       | Ok t -> t
  in { player = p ;
		object_list = l1 ;
       character_list = l2 ;
       texture_list = tl ;
       background = t ;
       width = w ;
       height = h;
       renderer = r;
       next_scene = next_scene;
     prev_scene = prev_scene } 
;;

let load_scene p file r h =
  let f = open_in file in
  let bg = input_line f in
  let texture_list = String.split_on_char ';' (input_line f) in
  let prev_next_scene = Array.of_list (String.split_on_char ';' (input_line f)) in
  let textures = Array.of_list (List.rev (List.fold_left (fun acc x -> let t = Tool.create_texture_from_image r x in t::acc) [] texture_list)) in
  let objects = ref [] in
  let characters = ref [] in
  try
    while true; 
    do
      let line = Array.of_list (String.split_on_char ';' (input_line f)) in
      if line.(0) = "c"
      then
	characters := (Objet.create (int_of_string line.(2)) (int_of_string line.(3)) textures.(int_of_string line.(1)) 0. 0 (int_of_string line.(4)) (int_of_string line.(5)) 0 100000000 false true true 3)::!characters
      else
	objects := (Objet.create (int_of_string line.(2)) ((int_of_string line.(3))) textures.(int_of_string line.(1)) 0. 0 (int_of_string line.(4)) (int_of_string line.(5)) 0 100000000 false (bool_of_string line.(6)) false 0)::!objects
    done; create r p !objects !characters (Array.to_list textures) bg 2000 750 prev_next_scene.(1) prev_next_scene.(0)
  with End_of_file -> close_in f; create r p !objects !characters (Array.to_list textures) bg 2000 750 prev_next_scene.(1) prev_next_scene.(0)
;;

let get_characters s = s.character_list ;;
let get_objects s = s.object_list ;;
let get_background s = s.background ;;
let get_width s = s.width ;;
let get_height s = s.height ;;
let get_player s = s.player ;;
let get_texture_list s = s.texture_list ;;
let get_renderer s = s.renderer ;;
let get_next_scene s = s.next_scene ;;
let get_prev_scene s = s.prev_scene ;;

let delete_scene s = match (get_texture_list s) with
  | [] -> ()
  | t::s -> Sdl.destroy_texture t
;;

let change_scene s1 s2 p x = delete_scene s1 ; load_scene {p with x = x } s2 (get_renderer s1) 768
;;

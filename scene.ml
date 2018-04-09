open Tsdl
open Result
open Objet
open Music
open Tsdl_mixer

type scene = { renderer : Sdl.renderer;
               width : int;
	           height : int;
	           background : Sdl.texture;
	           music : music;
			   player : unit; 
		       gameobjects : objet list ;
	           units : unit list ;
	           items : objet list ;
               next_scene : string;
               prev_scene : string } 
;;

let create renderer player gameobjects units items bg width height next_scene prev_scene music =
  let background = create_texture_from_image background in
  in { renderer;
       width
       height
       background;
       music;
       player;
       gameobjects;
       units;
       items;
       next_scene;
       prev_scene } 
;;

let load_scene player file renderer height music =
  let file = open_in file in
  let background = input_line file in
  let texture_list = String.split_on_char ';' (input_line file) in
  let prev_next_scene = Array.of_list (String.split_on_char ';' (input_line file)) in
  let textures = Array.of_list (List.rev (List.fold_left (fun acc x -> let t = Tool.create_texture_from_image r x in t::acc) [] texture_list)) in
  let gameobjects = ref [] in
  let units = ref [] in
  try
    while true; 
    do
      let line = Array.of_list (String.split_on_char ';' (input_line file)) in
      if line.(0) = "c"
      then
	    units := ({ (Unit.create (int_of_string line.(2)) (int_of_string line.(3)) textures.(int_of_string line.(1)) 1. 0 (int_of_string line.(4)) (int_of_string line.(5)) 0 100000000 false (bool_of_string line.(6)) true 3 [] false) with flip = true })::!units
      else
	    gameobjects := (Objet.create (int_of_string line.(2)) ((int_of_string line.(3))) textures.(int_of_string line.(1)) 0. 0 (int_of_string line.(4)) (int_of_string line.(5)) 0 100000000 false (bool_of_string line.(6)) false 0 [] false)::!gameobjects
    done;
    create renderer player !gameobjects !units [] background 2000 750 prev_next_scene.(1) prev_next_scene.(0) music
  with End_of_file -> close_in f; 
                      create renderer player !gameobjects !units [] background 2000 750 prev_next_scene.(1) prev_next_scene.(0) music
;;

let destroy_scene s =
  Sdl.destroy_texture (s.background);
  List.iter (Object.destroy) (s.items)
  List.iter (Unit.destroy) (s.units)
;;

let change_scene s1 s2 x = 
  let music = (get_music s1) in
  destroy_scene s1; 
  load_scene { s1.player with x = x } s2 (get_renderer s1) 768 music
;;

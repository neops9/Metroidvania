open Tsdl
open Tsdl_mixer
open Result
open Gameobject
open Music
open Player
open Character
open Tool

type scene = { renderer : Sdl.renderer;
               width : int;
	           height : int;
	           background : Sdl.texture;
	           music : music;
			   player : player; 
		       gameobjects : gameobject list ;
	           characters : character list ;
	           items : gameobject list ;
               next_scene : string;
               prev_scene : string } 
;;

let create renderer player gameobjects characters items bg width height next_scene prev_scene music =
  let background = create_texture_from_image renderer bg in
    { renderer;
      width;
      height;
      background;
      music;
      player;
      gameobjects;
      characters;
      items;
      next_scene;
      prev_scene } 
;;

let load player file renderer height music =
  let file = open_in file in
  let background = input_line file in
  let texture_list = String.split_on_char ';' (input_line file) in
  let prev_next_scene = Array.of_list (String.split_on_char ';' (input_line file)) in
  let textures = Array.of_list (List.rev (List.fold_left (fun acc x -> let t = Tool.create_texture_from_image renderer x in t::acc) [] texture_list)) in
  let gameobjects = ref [] in
  let characters = ref [] in
  try
    while true; 
    do
      let line = Array.of_list (String.split_on_char ';' (input_line file)) in
      let animation = Animation.create "Object" (int_of_string line.(4)) (int_of_string line.(5)) [textures.(int_of_string line.(1))] (-1) (-1) in
      if line.(0) = "c"
      then
        let projectile = Animation.create "projectile" 34 34 [(create_texture_from_image renderer "images/rock.bmp")] (-1) (-1) in
	    characters := (Character.create "Character" (int_of_string line.(2)) (int_of_string line.(3)) (-1) (1.) animation [animation] [] projectile false 3)::!characters
      else
	    gameobjects := (Gameobject.create "Gameobject" (int_of_string line.(2)) ((int_of_string line.(3))) 0 0. animation [animation] (bool_of_string line.(6)) false 1 (-1) [] false)::!gameobjects
    done;
    create renderer player !gameobjects !characters [] background 4000 750 prev_next_scene.(1) prev_next_scene.(0) music
  with End_of_file -> close_in file; 
                      create renderer player !gameobjects !characters [] background 4000 750 prev_next_scene.(1) prev_next_scene.(0) music
;;

let get_renderer s = s.renderer ;;
let get_width s = s.width ;;
let get_height s = s.height ;;
let get_player s = s.player ;;
let set_player s p = { s with player = p } ;;

let display_background p t r c =
  match Sdl.render_copy ~src:c r t  with
  | Error (`Msg e) ->  Sdl.log "Can't fill image error: %s" e; exit 1 
  | Ok () -> ()
;;

let display s c = 
  display_background s.player s.background s.renderer c;
  List.iter (Gameobject.display s.renderer c) (s.gameobjects);
  List.iter (Character.display s.renderer c) (s.characters);
  List.iter (Gameobject.display s.renderer c) (s.items);
  Player.display s.renderer c (s.player)
;;

let rec character_in_list c l = 
  match l with
  | [] -> false
  | x::s -> if (Character.get_name c) = (Character.get_name x) && (Character.get_dx c) = (Character.get_dx x) && (Character.get_dy c) = (Character.get_dy x) then true else character_in_list c s
;;

let rec apply_character_damages s =
let player_temp = s.player in
    { s with  player = { player_temp with damaged_characters = [] }; characters = List.map (fun x -> if character_in_list x player_temp.damaged_characters then begin if x.invulnerable_time <= 0 then { x with life = x.life -1; invulnerable_time = 300 } else x end else x) s.characters }
;;

let update s = 
  let s = (apply_character_damages s) in
  { s with player = Player.update s.player;
                        gameobjects = List.map (Gameobject.update) s.gameobjects; 
                        characters = List.fold_left (fun acc x -> if x.life <= 0 then acc else x::acc) [] (List.map (Character.update) (s.characters));
                        items = List.map (Gameobject.update) s.items }
;;

let destroy s =
  Sdl.destroy_texture (s.background);
  List.iter (Gameobject.destroy) (s.gameobjects);
  List.iter (Gameobject.destroy) (s.items);
  List.iter (Character.destroy) (s.characters)
;;

let change_scene s1 s2 x = 
  let music = s1.music in
  destroy s1; 
  load { s1.player with x = x } s2 (get_renderer s1) 768 music
;;

let rec move_projectiles_player p cl gl = 
match cl, gl with
| [], [] -> p
| c::s, _ -> if collision_rec (player_to_rect p) (List.fold_left (fun acc o -> (gameobject_to_rect { o with x = (Gameobject.get_x o) + (Gameobject.get_vx o); y = (Gameobject.get_y o) + int_of_float((Gameobject.get_vy o)) })::acc) [] (Character.get_projectiles c)) then { p with life = p.life - 1 } else move_projectiles_player p s gl
| _, g::s -> if collision_rec (player_to_rect p) (List.fold_left (fun acc o -> (gameobject_to_rect { o with x = (Gameobject.get_x o) + (Gameobject.get_vx o); y = (Gameobject.get_y o) + int_of_float((Gameobject.get_vy o)) })::acc) [] (Gameobject.get_projectiles g)) then { p with life = p.life - 1 } else move_projectiles_player p cl s
;;

let move_projectiles_gameobjects gl p = 
List.map (fun g -> if collision_rec (gameobject_to_rect g) (List.fold_left (fun acc o -> (gameobject_to_rect { o with x = (Gameobject.get_x o) + (Gameobject.get_vx o); y = (Gameobject.get_y o) + int_of_float((Gameobject.get_vy o)) })::acc) [] (Player.get_projectiles p)) then { g with life = g.life - 1 } else g) gl
;;

let move_projectiles_characters cl p = 
List.map (fun c -> if collision_rec (character_to_rect c) (List.fold_left (fun acc o -> (gameobject_to_rect { o with x = (Gameobject.get_x o) + (Gameobject.get_vx o); y = (Gameobject.get_y o) + int_of_float((Gameobject.get_vy o)) })::acc) [] (Player.get_projectiles p)) then { c with life = c.life - 1 } else c) cl
;;

let move s =
  let gameobjects = move_projectiles_gameobjects s.gameobjects s.player in
  let characters = move_projectiles_characters s.characters s.player in
  let p = move_projectiles_player s.player s.characters s.gameobjects in
  if (p.x > s.width) then
    change_scene s s.next_scene 10
  else if (p.x < 0) then
    change_scene s s.prev_scene 3970
  else
    let l1 = List.fold_left (fun acc x -> if Gameobject.is_collision x then (Gameobject.gameobject_to_rect x)::acc else acc) [] gameobjects in
    let l2 = List.fold_left (fun acc x -> if Gameobject.is_collision x then (Gameobject.gameobject_to_rect x)::acc else acc) [] s.items in
    let l3 = List.fold_left (fun acc x -> if Character.is_collision x then (Character.character_to_rect x)::acc else acc) [] characters in
    let l4 = List.fold_left (fun acc x -> (Player.player_to_rect x)::acc) [] [p] in
    let l = List.append l4 (List.append l3 (List.append l1 l2)) in
    { s with player = Player.move (List.append l3 (List.append l1 l2)) characters p; 
             gameobjects = List.map (Gameobject.move l) gameobjects;                        
             characters = List.map (Character.move l) characters;
             items = List.map (Gameobject.move l) s.items }
;;

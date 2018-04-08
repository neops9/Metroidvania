open Tsdl
open Result
open Objet
open Tool
open Scene
open Bigarray
open Menu
open Tsdl_mixer
open Son

(*eval $(opam config env)*)
(*ocamlbuild -use-ocamlfind -package tsdl,tsdl_mixer main.byte*)

(* CTRL X / H / TAB *)

(* 

   TODO:

   - Animation de saut

   - Adversaire
   - animation de tir
   - living time : trouver une solution pour pas avoir à mettre le time to live des gens
   qui reste tout le temps à 10000000000

 *)

let window_width = 1024;;
let window_height = 768;;

let sounds_list () = 
  let s1 = Son.create "jump" (Tool.load_chunk "sounds/jump.wav") in
  let s2 = Son.create "throw" (Tool.load_chunk "sounds/throw.wav") in
  let s3 = Son.create "lose" (Tool.load_chunk "sounds/lose.wav") in
  let s4 = Son.create "gameover" (Tool.load_chunk "sounds/gameover.wav") in
  [s1;s2;s3;s4]
;;

let keyboard_scene_actions s r =
  let keystates = Sdl.get_keyboard_state () in
  let p = (get_player s) in
  if (keystates.{ Tool.scancode "a" } <> 0 && ((get_bullet_time p) <= 0)) then begin
      Mixer.play_channel (-1) (Objet.get_sound p "throw") 0;
      if Objet.is_flip p then 
        let bullet = Objet.create ((Objet.get_x p) - 50) ((Objet.get_y p) + 50) (Tool.create_texture_from_image r "images/rock.bmp") (-10.) (-8) 34 34 0 1000 false false false 0 [] true in
        { s with player = { p with bullet_time = 20 } ; object_list = bullet::(s.object_list) }
      else
        let bullet = Objet.create ((Objet.get_x p) + 100) ((Objet.get_y p) + 50) (Tool.create_texture_from_image r "images/rock.bmp") (-10.) 8 34 34 0 1000 false false false 0 [] true in
        { s with player = { p with bullet_time = 20 } ; object_list = bullet::(s.object_list) }
    end
  else
    s
;;

let keyboard_player_actions p = 
  let keystates = Sdl.get_keyboard_state () in
  if (keystates.{ Tool.scancode "up" } <> 0) && not (Objet.is_in_air p) && (Objet.get_vy p) = 0. then begin
    Mixer.play_channel (-1) (Objet.get_sound p "jump") 0;
    { p with in_air = true; vy = -12. } end
  else if keystates.{ Tool.scancode "left" } <> 0 then
    { p with vx = -10; frame = (((Objet.get_frame p)+1) mod 25); flip = true }
  else if keystates.{ Tool.scancode "right" } <> 0 then
    { p with vx = 10; frame = (((Objet.get_frame p)+1) mod 25); flip = false }
  else if keystates.{ Tool.scancode "right" } = 0 then
    Objet.set_vx p 0
  else if keystates.{ Tool.scancode "left" } = 0 then
    Objet.set_vx p 0
  else
    p
;;

let rec wait p s r w c m =
  Sdl.delay 2l ;
  let p = keyboard_player_actions (Movement.move_object s p (Objet.update p r)) in
  let s = { s with player = p } in
  let s = keyboard_scene_actions (Movement.move_scene s p) r in
  let p = get_player s in
  if (Objet.get_life p) = 0 then
begin
    Mixer.free_music m;
    let menu = Menu.load_menu r in
    Display.display_menu menu r; menu_loop menu w r
end
  else
    begin
      Camera.move c s p;
      let event = Sdl.Event.create () in
      match Sdl.poll_event (Some(event)) with
      | false -> Display.display_game p s r c; 
                 wait p s r w c m
      | true -> match Sdl.Event.(enum (get event typ )) with
                | `Quit -> Mixer.free_music m; Sdl.destroy_renderer r; Sdl.destroy_window w; Mixer.quit (); Sdl.quit (); 
                | _ -> Display.display_game p s r c; 
                       wait p s r w c m
    end
and
menu_loop m w r =
  let event = Sdl.Event.create () in
  match Sdl.wait_event (Some(event)) with
  | Error (`Msg e) -> menu_loop m w r
  | Ok() -> match Sdl.Event.(enum (get event typ )) with
            | `Quit -> Sdl.destroy_renderer r; Sdl.destroy_window w; Sdl.quit ()
            | `Key_down -> if Sdl.Event.(get event keyboard_keycode) = Sdl.K.return then
                             begin
                               match Menu.get_action m with
                               | "Jouer" -> begin
                                  let personnage = Objet.create 10 800 (Tool.create_texture_from_image r "images/char0.bmp") 0. 0 79 100 0 1000000000 true true true 3 (sounds_list ()) false in
	                          let scene = Scene.load_scene personnage "level/scene1" r window_height in
	                          let camera = Camera.create (Sdl.Rect.create 0 0 640 480) window_width window_height in
				  match Mixer.load_mus "music/level.wav" with
  	     				    | Error (`Msg e) ->  Sdl.log "Can't load music error: %s" e; exit 1
 	     				    | Ok music -> Menu.destroy_menu m; Mixer.play_music music (-1); wait (get_player scene) scene r w camera music
				end
                               | "Quitter" -> Menu.destroy_menu m; Sdl.destroy_renderer r; Sdl.destroy_window w; Mixer.quit (); Sdl.quit ()
                               | _ -> menu_loop m w r
                             end
                           else if Sdl.Event.(get event keyboard_keycode) = Sdl.K.up || Sdl.Event.(get event keyboard_keycode) = Sdl.K.down then
                             let m = Menu.update_boutons m in
			     Mixer.play_channel (-1) (Menu.get_son m) 0;
                             Display.display_menu m r; menu_loop m w r
                           else menu_loop m w r
            | _ -> menu_loop m w r
;;

let main () = match Sdl.init Sdl.Init.(video + audio) with
  | Error (`Msg e) -> Sdl.log "Init error: %s" e; exit 1
  | Ok () -> match Sdl.create_window ~w:window_width ~h:window_height "Raccoon's Adventure" Sdl.Window.opengl with
             | Error (`Msg e) -> Sdl.log "Create window error: %s" e; exit 1
             | Ok w -> Sdl.set_window_icon w (Tool.create_surface_from_image "images/mushroom1.bmp"); match Sdl.create_renderer ~flags:Sdl.Renderer.(accelerated + presentvsync) w with
                       | Error (`Msg e) ->  Sdl.log "Can't create renderer error: %s" e; exit 1
                       | Ok r -> Sdl.set_window_resizable w true;
                                 match Mixer.open_audio 44100 Sdl.Audio.s16_sys 2 2048 with
				 | Error (`Msg e) -> Sdl.log "Can't open audio: %s" e; exit 1
				 | Ok () -> let menu = Menu.load_menu r in
						Display.display_menu menu r; menu_loop menu w r

let () = main () ;;

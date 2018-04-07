open Tsdl
open Result
open Objet
open Tool
open Scene
open Bigarray
open Menu

(*eval $(opam config env)*)
(*ocamlbuild -use-ocamlfind -package tsdl,tsdl_mixer main.byte*)

(* CTRL X / H / TAB *)

(* 

   TODO:

   - Animation de saut
   - Gérer la cadence de tir : FAIT
   - Changement de scène
   - Vie
   - Adversaire
   - Menu
   - animation de tir
   - living time : trouver une solution pour pas avoir à mettre le time to live des gens
   qui reste tout le temps à 10000000000

 *)

let window_width = 1024;;
let window_height = 768;;

let keyboard_scene_actions s r =
  let keystates = Sdl.get_keyboard_state () in
  let p = (get_player s) in
  if (keystates.{ Tool.scancode "a" } <> 0 && ((get_bullet_time p) <= 0)) then begin
      if Objet.is_flip p then 
        let bullet = Objet.create ((Objet.get_x p) - 10) ((Objet.get_y p) + 50) (Tool.create_texture_from_image r "images/noisette.bmp") 0. (-13) 10 10 0 1000 false false false 0 in
        { s with player = { p with bullet_time = 10 } ; object_list = bullet::(s.object_list) }
      else
        let bullet = Objet.create ((Objet.get_x p) + 80) ((Objet.get_y p) + 50) (Tool.create_texture_from_image r "images/noisette.bmp") 0. 13 10 10 0 1000 false false false 0 in
        { s with player = { p with bullet_time = 10 } ; object_list = bullet::(s.object_list) }
    end
  else
    s
;;

let keyboard_player_actions p = 
  let keystates = Sdl.get_keyboard_state () in
  if (keystates.{ Tool.scancode "up" } <> 0) && not (Objet.is_in_air p) && (Objet.get_vy p) = 0. then
    { p with in_air = true; vy = -12. }
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

let rec wait p s r w c =
  Sdl.delay 10l ;
  let p = keyboard_player_actions (Movement.move_object s (Objet.update p r)) in
  let s = { s with player = p } in
  let s = keyboard_scene_actions (Movement.move_scene s p) r in
  let p = get_player s in
  Camera.move c s p;
  let event = Sdl.Event.create () in
  match Sdl.poll_event (Some(event)) with
  | false -> Display.display_game p s r c; 
             wait p s r w c
  | true -> match Sdl.Event.(enum (get event typ )) with
              |`Quit -> Sdl.destroy_renderer r; Sdl.destroy_window w; Sdl.quit ()
            | _ -> Display.display_game p s r c; 
                   wait p s r w c
;;

let rec menu_loop m w r =
  let event = Sdl.Event.create () in
  match Sdl.poll_event (Some(event)) with
  | false -> menu_loop m w r
  | true -> match Sdl.Event.(enum (get event typ )) with
            | `Quit -> Sdl.destroy_renderer r; Sdl.destroy_window w; Sdl.quit ()
            | `Key_down -> if Sdl.Event.(get event keyboard_keycode) = Sdl.K.return then begin
               let personnage = Objet.create 10 200 (Tool.create_texture_from_image r "images/char0.bmp") 0. 0 79 100 0 1000000000 false true true 3 in
	                   let scene = Scene.load_scene personnage "level/scene1" r window_height in
	                   let camera = Camera.create (Sdl.Rect.create 0 0 640 480) window_width window_height in
                           Menu.destroy_menu m; wait (get_player scene) scene r w camera
                             end
                           else
                             Display.display_menu m r; menu_loop m w r
            | _ -> Display.display_menu m r; menu_loop m w r
;;

let main () = match Sdl.init Sdl.Init.video with
  | Error (`Msg e) -> Sdl.log "Init error: %s" e; exit 1
  | Ok () -> match Sdl.create_window ~w:window_width ~h:window_height "Metroidvania" Sdl.Window.opengl with
             | Error (`Msg e) -> Sdl.log "Create window error: %s" e; exit 1
             | Ok w -> match Sdl.create_renderer ~flags:Sdl.Renderer.(accelerated + presentvsync) w with
                       | Error (`Msg e) ->  Sdl.log "Can't create renderer error: %s" e; exit 1
                       | Ok r -> Sdl.set_window_resizable w true;
                                 let menu = Menu.load_menu r in
                                 menu_loop menu w r
;;

let () = main () ;;

open Tsdl
open Result
open Objet
open Tool
open Scene
open Bigarray
open Menu
open Tsdl_mixer
open Music
open Sound
open Keyboard
open Display
open Movement

let window_width = 1024;;
let window_height = 768;;

let sounds_list () = 
  let s1 = Sound.create "jump" (Tool.load_chunk "sounds/jump.wav") in
  let s2 = Sound.create "throw" (Tool.load_chunk "sounds/throw.wav") in
  let s3 = Sound.create "lose" (Tool.load_chunk "sounds/lose.wav") in
  let s4 = Sound.create "gameover" (Tool.load_chunk "sounds/gameover.wav") in
  [s1;s2;s3;s4]
;;

let quit_game r w =
  Sdl.destroy_renderer r;
  Sdl.destroy_window w;
  Mixer.quit ();
  Sdl.quit ()
;;

let rec game_loop s w c =
  Sdl.delay 2l;
  let s = keyboard_actions (move_scene s) in
  let p = get_player s in
  if (Objet.get_life p) = 0 then
	begin
      destroy_scene s;
      let menu = load_menu (Scene.get_renderer s) in
      display_menu menu;
      menu_loop menu w
	end
  else
    begin
      Camera.move c s p;
      let event = Sdl.Event.create () in
      match Sdl.poll_event (Some(event)) with
	  | false -> display_game s (Scene.get_renderer s) c; game_loop s w c
      | true -> match Sdl.Event.(enum (get event typ )) with
                | `Quit -> Sdl.destroy_renderer (Scene.get_renderer s);
                           destroy_scene s;
                           Sdl.destroy_window w; 
                           Mixer.quit (); 
                           Sdl.quit (); 
                | _ -> display_game s (Scene.get_renderer s) c; game_loop s w c
    end
and
  menu_loop m w =
  let event = Sdl.Event.create () in
  match Sdl.wait_event (Some(event)) with
  | Error (`Msg e) -> menu_loop m w
  | Ok() -> match Sdl.Event.(enum (get event typ )) with
            | `Quit -> destroy_menu m;
                       quit_game (Menu.get_renderer m) w
            | `Key_down -> if Sdl.Event.(get event keyboard_keycode) = Sdl.K.return then
                             begin
                               match get_action m with
                               | "Jouer" -> 
                                 begin
                                   let player = Objet.create 10 800 (create_texture_from_image (Menu.get_renderer m) "images/char0.bmp") 0. 0 79 100 0 1000000000 true true true 3 (sounds_list ()) false in
	                               let camera = Camera.create (Sdl.Rect.create 0 0 640 480) window_width window_height in
				                   let music = Music.create "level1_music" (load_music "music/level.wav") in
				                   let scene = load_scene player "level/scene1" (Menu.get_renderer m) window_height music in
  	     				           destroy_menu m;
  	     				           play_music music;
  	     				           game_loop scene w camera
				                 end
                               | "Quitter" -> destroy_menu m; 
                                              quit_game (Menu.get_renderer m) w
                               | _ -> menu_loop m w
                             end
                           else if Sdl.Event.(get event keyboard_keycode) = Sdl.K.up || Sdl.Event.(get event keyboard_keycode) = Sdl.K.down then
                             let m = update_buttons m in
							 play_sound (get_button_sound m) ;
                             display_menu m; menu_loop m w
                           else menu_loop m w
            | _ -> menu_loop m w
;;

let main () = match Sdl.init Sdl.Init.(video + audio) with
  | Error (`Msg e) -> Sdl.log "Init error: %s" e; exit 1
  | Ok () -> match Sdl.create_window ~w:window_width ~h:window_height "Raccoon's Adventure" Sdl.Window.opengl with
             | Error (`Msg e) -> Sdl.log "Create window error: %s" e; exit 1
             | Ok w -> Sdl.set_window_icon w (Tool.create_surface_from_image "images/mushroom1.bmp");
				       match Sdl.create_renderer ~flags:Sdl.Renderer.(accelerated + presentvsync) w with
                       | Error (`Msg e) ->  Sdl.log "Can't create renderer error: %s" e; exit 1
                       | Ok r -> Sdl.set_window_resizable w true;
                                 match Mixer.open_audio 44100 Sdl.Audio.s16_sys 2 2048 with
				                 | Error (`Msg e) -> Sdl.log "Can't open audio: %s" e; exit 1
				                 | Ok () -> let menu = Menu.load_menu r in
						                    display_menu menu; 
						                    menu_loop menu w

let () = main () ;;

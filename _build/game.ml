open Tsdl
open Tsdl_mixer
open Result
open Gameobject
open Character
open Tool
open Scene
open Bigarray
open Menu
open Music
open Sound
open Keyboard
open Animation

type game = { window : Sdl.window;
              renderer : Sdl.renderer;
              menu : Menu.menu }
;;

let create window renderer menu = { window; renderer; menu }

let get_menu g = g.menu ;;
let get_window g = g.window ;;
let get_renderer g = g.renderer ;;

let display_user_interface r c p = 
  let offset = ref 15 in
  for i = 1 to Player.get_life p do
    let heart_animation = Animation.create "hearth" 50 50 [(Tool.create_texture_from_image r "images/life.bmp")] (-1) (-1) in
    let heart = Gameobject.create "heart" ((Sdl.Rect.x c) + !offset) ((Sdl.Rect.y c) + 15) 0 0. heart_animation [heart_animation] false false 1 (-1) [] false in
    offset := !offset + 60;
    Gameobject.display r c heart
  done;
;;

let display_game s c =
  let r = Scene.get_renderer s in
  let rect = Camera.get_rect c in
  Sdl.render_clear r;
  Scene.display s rect;
  display_user_interface r rect (Scene.get_player s);
  Sdl.render_present r;
;;

let quit g =
  Sdl.destroy_renderer (get_renderer g);
  Sdl.destroy_window (get_window g);
  Mixer.quit ();
  Sdl.quit ()
;;

let sounds_list () = 
  let s1 = Sound.create "jump" (Tool.load_chunk "sounds/jump.wav") in
  let s2 = Sound.create "throw" (Tool.load_chunk "sounds/throw.wav") in
  let s3 = Sound.create "lose" (Tool.load_chunk "sounds/lose.wav") in
  let s4 = Sound.create "gameover" (Tool.load_chunk "sounds/gameover.wav") in
  [s1;s2;s3;s4]
;;

let player_animations r = 
  let t1 = create_texture_from_image r "images/run1.bmp" in
  let t2 = create_texture_from_image r "images/run2.bmp" in
  let t3 = create_texture_from_image r "images/run3.bmp" in
  let t4 = create_texture_from_image r "images/run4.bmp" in
  let t5 = create_texture_from_image r "images/run5.bmp" in
  let t6 = create_texture_from_image r "images/run6.bmp" in
  let t7 = create_texture_from_image r "images/run7.bmp" in
  let t8 = create_texture_from_image r "images/run8.bmp" in
  let t9 = create_texture_from_image r "images/run9.bmp" in
  let t10 = create_texture_from_image r "images/run10.bmp" in
  let t11 = create_texture_from_image r "images/run11.bmp" in
  let t12 = create_texture_from_image r "images/run12.bmp" in
  let i1 = create_texture_from_image r "images/idle1.bmp" in
  let i2 = create_texture_from_image r "images/idle2.bmp" in
  let i3 = create_texture_from_image r "images/idle3.bmp" in
  let i4 = create_texture_from_image r "images/idle4.bmp" in
  let i5 = create_texture_from_image r "images/idle5.bmp" in
  let i6 = create_texture_from_image r "images/idle6.bmp" in
  let i7 = create_texture_from_image r "images/idle7.bmp" in
  let i8 = create_texture_from_image r "images/idle8.bmp" in
  let i9 = create_texture_from_image r "images/idle9.bmp" in
  let i10 = create_texture_from_image r "images/idle10.bmp" in
  let i11 = create_texture_from_image r "images/idle11.bmp" in
  let j1 = create_texture_from_image r "images/jump1.bmp" in
  let j2 = create_texture_from_image r "images/jump2.bmp" in
  let j3 = create_texture_from_image r "images/jump3.bmp" in
  let j4 = create_texture_from_image r "images/jump4.bmp" in
  let j5 = create_texture_from_image r "images/jump5.bmp" in
  let j6 = create_texture_from_image r "images/jump6.bmp" in
  let j7 = create_texture_from_image r "images/jump7.bmp" in
  let j8 = create_texture_from_image r "images/jump8.bmp" in
  let j9 = create_texture_from_image r "images/jump9.bmp" in
  let j10 = create_texture_from_image r "images/jump10.bmp" in
  let j11 = create_texture_from_image r "images/jump11.bmp" in
  let a1 = Animation.create "idle" 79 100 [i1;i2;i3;i4;i5;i6;i7;i8;i9;i10;i11] 3 (-1) in
  let a2 = Animation.create "run" 79 100 [t1;t2;t3;t4;t5;t6;t7;t8;t9;t10;t11;t12] 1 (-1) in
  let a3 = Animation.create "jump" 79 100 [j1;j2;j3;j4;j5;j6;j7;j8;j9;j10;j11] 5 1 in
  [a1; a2; a3]
;;

let rec game_loop g s c =
  Sdl.delay 5l;
  let s = keyboard_actions (Scene.move (Scene.update s)) in
  let p = s.player in
  if p.life = 0 then
	begin
	let g = {g with menu = Menu.load g.renderer } in
      Scene.destroy s;
      Menu.display g.menu;
      menu_loop g      
	end
  else
    begin
      Camera.move c p (Scene.get_height s) (Scene.get_width s);
      let event = Sdl.Event.create () in
      match Sdl.poll_event (Some(event)) with
	  | false -> display_game s c; 
	             game_loop g s c
      | true -> match Sdl.Event.(enum (get event typ )) with
                | `Quit -> Scene.destroy s;
                           quit g 
                | _ -> display_game s c;
                       game_loop g s c
    end
and
  menu_loop g =
  let event = Sdl.Event.create () in
  let menu = get_menu g in
  match Sdl.wait_event (Some(event)) with
  | Error (`Msg e) -> menu_loop g
  | Ok() -> match Sdl.Event.(enum (get event typ )) with
            | `Quit -> Menu.destroy menu;
                       quit g
            | `Key_down -> if Sdl.Event.(get event keyboard_keycode) = Sdl.K.return then
                             begin
                               match get_action menu with
                               | "Jouer" -> 
                                 begin
                                   let renderer = Menu.get_renderer menu in
                                   let t1 = create_texture_from_image renderer "images/rock.bmp" in
									let t2 = create_texture_from_image renderer "images/rock1.bmp" in
									let t3 = create_texture_from_image renderer "images/rock2.bmp" in
									let t4 = create_texture_from_image renderer "images/rock3.bmp" in
									let t5 = create_texture_from_image renderer "images/rock4.bmp" in
									let t6 = create_texture_from_image renderer "images/rock5.bmp" in
                                   let projectile = Animation.create "projectile" 34 34 [t1;t2;t3;t4;t5;t6] 1 (-1) in
                                   let player = Player.create "Player" 10 600 0 2. (List.hd (player_animations renderer)) (player_animations renderer) (sounds_list ()) projectile false 3 in
	                               let camera = Camera.create (Sdl.Rect.create 0 0 940 700) 1024 768 in
				                   let music = Music.create "level1_music" (load_music "music/level.wav") in
				                   let scene = Scene.load player "level/scene1" renderer 768 music in
  	     				           Menu.destroy g.menu;
  	     				           Music.play music;
  	     				           game_loop g scene camera
				                 end
                               | "Quitter" -> Menu.destroy menu; 
                                              quit g
                               | _ -> menu_loop g
                             end
                           else if Sdl.Event.(get event keyboard_keycode) = Sdl.K.up || Sdl.Event.(get event keyboard_keycode) = Sdl.K.down then
                           begin
                             let g = { g with menu = update_buttons menu } in
							 Sound.play (Button.get_sound (Menu.get_selected_button menu));
                             Menu.display g.menu;
                             menu_loop g end
                           else menu_loop g
            | _ -> menu_loop g
;;

let launch_game g = Menu.display (get_menu g); menu_loop g ;;

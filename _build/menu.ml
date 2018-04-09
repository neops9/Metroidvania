open Tsdl
open Button
open Tsdl_mixer
open Music
open Sound

type menu = { renderer : Sdl.renderer; bg : Sdl.texture ; button_list : button list; music : music; button_sound : sound } ;;

let create renderer bg button_list music button_sound = { renderer; bg ; button_list; music; button_sound } ;;

let get_button_list m = m.button_list ;;
let get_bg m = m.bg ;;
let get_music m = m.music ;;
let get_button_sound m = m.button_sound ;;
let get_renderer m = m.renderer ;;

let load_menu r =
  let bg_texture = Tool.create_texture_from_image r "images/menu.bmp" in
  let b1_texture = Tool.create_texture_from_image r "images/bouton_jouer.bmp" in
  let b2_texture = Tool.create_texture_from_image r "images/bouton_quitter.bmp" in
  let b1 = Button.create "Jouer" b1_texture 420 350 168 78 true in
  let b2 = Button.create "Quitter" b2_texture 403 470 207 78 false in
  let s1 = Sound.create "bouton" (Tool.load_chunk "sounds/bouton_select.wav") in
  let music = Music.create "menu_music" (Tool.load_music "music/menu.wav") in
  play_music music;
  create r bg_texture [b1;b2] music s1
;;

let destroy_menu m =
  free_music (get_music m);
  Sdl.destroy_texture (get_bg m);
  let rec delete_buttons l =
  match l with
  | [] -> ()
  | b::s -> Sdl.destroy_texture (Button.get_texture b); delete_buttons s
  in
  delete_buttons (get_button_list m);
;;

let update_buttons m = let buttons = List.map (fun x -> set_selected x (not (is_selected x))) (get_button_list m) in
                       { m with button_list = buttons }
;;

let get_action m =
  let rec get_button l =
    match l with
    | [] -> "Jouer"
    | b::next -> if Button.is_selected b then Button.get_name b else get_button next
  in
  get_button (get_button_list m)
;;


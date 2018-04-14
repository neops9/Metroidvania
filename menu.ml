open Tsdl
open Button
open Tsdl_mixer
open Music
open Sound

type menu = { renderer : Sdl.renderer;
              bg : Sdl.texture;
              buttons : button list;
              music : music
            }
;;

let create renderer bg buttons music = { renderer; bg ; buttons; music } ;;

let load r =
  let bg_texture = Tool.create_texture_from_image r "images/menu.bmp" in
  let b1_texture = Tool.create_texture_from_image r "images/bouton_jouer.bmp" in
  let b2_texture = Tool.create_texture_from_image r "images/bouton_quitter.bmp" in
  let s1 = Sound.create "bouton" (Tool.load_chunk "sounds/bouton_select.wav") in
  let b1 = Button.create "Jouer" b1_texture 420 350 168 78 s1 true in
  let b2 = Button.create "Quitter" b2_texture 403 470 207 78 s1 false in
  let music = Music.create "menu_music" (Tool.load_music "music/menu.wav") in
  Music.play music;
  create r bg_texture [b1;b2] music
;;

let get_renderer m = m.renderer ;;
let get_bg m = m.bg ;;
let get_music m = m.music ;;

let destroy m =
  Music.free m.music;
  Sdl.destroy_texture m.bg;
  let rec delete_buttons l =
  match l with
  | [] -> ()
  | b::s -> Sdl.destroy_texture (Button.get_texture b); delete_buttons s
  in
  delete_buttons m.buttons;
;;

let update_buttons m = let buttons = List.map (fun x -> set_selected x (not (is_selected x))) (m.buttons) in
                       { m with buttons = buttons }
;;

let display m =
  Sdl.render_clear m.renderer;
  match Sdl.render_copy m.renderer m.bg  with
  | Error (`Msg e) ->  Sdl.log "Can't fill image error: %s" e; exit 1 
  | Ok () -> List.iter (Button.display m.renderer) (m.buttons); Sdl.render_present (m.renderer)
;;

exception No_selected_button ;;

let get_selected_button m =
  let rec get_selected_button_rec l =
  match l with
  | [] -> raise No_selected_button
  | b::next -> if Button.is_selected b then b else get_selected_button_rec next
  in
  get_selected_button_rec m.buttons
;;

let get_action m =
  let rec get_button l =
    match l with
    | [] -> "Jouer"
    | b::next -> if Button.is_selected b then Button.get_name b else get_button next
  in
  get_button m.buttons
;;


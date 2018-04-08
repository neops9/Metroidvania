open Tsdl
open Bouton
open Tsdl_mixer
open Son

type menu = { bg : Sdl.texture ; bouton_list : bouton list; music : Mixer.music; son_bouton : son } ;;

let create bg bouton_list music son_bouton = { bg ; bouton_list; music; son_bouton } ;;

let get_bouton_list m = m.bouton_list ;;
let get_bg m = m.bg ;;
let get_music m = m.music ;;
let get_son m = (Son.get_music) (m.son_bouton) ;;

let load_menu r =
  let bg_texture = Tool.create_texture_from_image r "images/menu.bmp" in
  let b1_texture = Tool.create_texture_from_image r "images/bouton_jouer.bmp" in
  let b2_texture = Tool.create_texture_from_image r "images/bouton_quitter.bmp" in
  let b1 = Bouton.create "Jouer" b1_texture 420 350 168 78 true in
  let b2 = Bouton.create "Quitter" b2_texture 403 470 207 78 false in
  let s1 = Son.create "bouton" (Tool.load_chunk "sounds/bouton_select.wav") in
  match Mixer.load_mus "music/menu.wav" with
  | Error (`Msg e) ->  Sdl.log "Can't load music error: %s" e; exit 1
  | Ok music -> Mixer.play_music music (-1); create bg_texture [b1;b2] music s1
;;

let destroy_menu m =
  Mixer.free_music (get_music m) ;
  Sdl.destroy_texture (get_bg m) ;
  let rec delete_bouton_menu l =
  match l with
  | [] -> ()
  | b::s -> Sdl.destroy_texture (Bouton.get_texture b); delete_bouton_menu s
  in
  delete_bouton_menu (get_bouton_list m)
;;

let update_boutons m = let boutons = List.map (fun x -> { x with est_bouton_courant = not (Bouton.est_courant x) }) (get_bouton_list m) in
                       { m with bouton_list = boutons }
;;

let get_action m =
  let rec get_bouton l =
    match l with
    | [] -> "Jouer"
    | b::next -> if Bouton.est_courant b then Bouton.get_nom b else get_bouton next
  in
  get_bouton (get_bouton_list m)
;;


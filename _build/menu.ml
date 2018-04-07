open Tsdl
open Bouton

type menu = { bg : Sdl.texture ; bouton_list : bouton list } ;;

let create bg bouton_list = { bg ; bouton_list } ;;

let get_bouton_list m = m.bouton_list ;;
let get_bg m = m.bg ;;

let load_menu r =
  let bg_texture = Tool.create_texture_from_image r "images/bg.bmp" in
  let b1_texture = Tool.create_texture_from_image r "images/ground1.bmp" in
  let b2_texture = Tool.create_texture_from_image r "images/ground2.bmp" in
  let b1 = Bouton.create "Jouer" b1_texture 100 200 128 128 in
  let b2 = Bouton.create "Quitter" b2_texture 100 500 128 128 in
  create bg_texture [b1;b2]
;;

let destroy_menu m =
  Sdl.destroy_texture (get_bg m) ;
  let rec delete_bouton_menu l =
  match l with
  | [] -> ()
  | b::s -> Sdl.destroy_texture (Bouton.get_texture b); delete_bouton_menu s
  in
  delete_bouton_menu (get_bouton_list m)
;;

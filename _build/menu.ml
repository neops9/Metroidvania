open Tsdl
open Bouton

type menu = { bg : Sdl.texture ; bouton_list : bouton list } ;;

let create bg bouton_list = { bg ; bouton_list } ;;

let get_bouton_list m = m.bouton_list ;;
let get_bg m = m.bg ;;

let load_menu r =
  let bg_texture = Tool.create_texture_from_image r "images/menu.bmp" in
  let b1_texture = Tool.create_texture_from_image r "images/bouton_jouer.bmp" in
  let b2_texture = Tool.create_texture_from_image r "images/bouton_quitter.bmp" in
  let b1 = Bouton.create "Jouer" b1_texture 420 350 168 78 true in
  let b2 = Bouton.create "Quitter" b2_texture 403 470 207 78 false in
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

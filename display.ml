open Tsdl
open Tool
open Scene

let rec display_object l r c =  match l with 
  | [] -> ()
  | o::next ->
     let rect = (Sdl.Rect.create ((Objet.get_x o) - (Sdl.Rect.x c))  ((Objet.get_y o) - (Sdl.Rect.y c)) (Objet.get_dx o) (Objet.get_dy o)) in
     if Objet.is_flip o then
       match Sdl.render_copy_ex ~dst:rect r (Objet.get_texture o) 0. None Sdl.Flip.horizontal with
       | Error (`Msg e) ->  Sdl.log "Can't fill image error: %s" e; exit 1 
       | Ok () -> display_object next r c
     else
       match Sdl.render_copy ~dst:rect r (Objet.get_texture o)  with
       | Error (`Msg e) ->  Sdl.log "Can't fill image error: %s" e; exit 1 
       | Ok () -> display_object next r c
;;

let rec display_personnage p r c = 
  let rect = (Sdl.Rect.create ((Objet.get_x p) - (Sdl.Rect.x c))  ((Objet.get_y p) - (Sdl.Rect.y c)) (Objet.get_dx p) (Objet.get_dy p)) in
  let coeurs = ref [] in
  let offset = ref 15 in
  for i = 1 to (Objet.get_life p) do
    coeurs := (Objet.create ((Sdl.Rect.x c) + !offset) ((Sdl.Rect.y c) + 15) (Tool.create_texture_from_image r "images/life.bmp") 0. 0 50 50 0 1000000000 false true true 0)::(!coeurs);
    offset := !offset + 60
  done;
     if Objet.is_flip p then
       match Sdl.render_copy_ex ~dst:rect r (Objet.get_texture p) 0. None Sdl.Flip.horizontal with
       | Error (`Msg e) ->  Sdl.log "Can't fill image error: %s" e; exit 1 
       | Ok () -> display_object !coeurs r c
     else
       match Sdl.render_copy ~dst:rect r (Objet.get_texture p)  with
       | Error (`Msg e) ->  Sdl.log "Can't fill image error: %s" e; exit 1 
       | Ok () -> display_object !coeurs r c
;;

let display_background t r c =
  match Sdl.render_copy ~src:c r t  with
  | Error (`Msg e) ->  Sdl.log "Can't fill image error: %s" e; exit 1 
  | Ok () -> ()
;;

let display_scene s r c = 
  display_background (Scene.get_background s) r c ; 
  display_object (s.object_list) r c; 
  display_object (s.character_list) r c
;;

let display_game p s r c =
  Sdl.render_clear r; 
  display_scene s r (Camera.get_rect c); 
  display_personnage p r (Camera.get_rect c); 
  Sdl.render_present r
;;

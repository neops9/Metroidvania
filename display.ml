open Tsdl
open Tool
open Scene
open Menu
open Button
open Objet
open Tsdl_mixer

let display_object r c o =  
  let rect = (Sdl.Rect.create ((Objet.get_x o) - (Sdl.Rect.x c))  ((Objet.get_y o) - (Sdl.Rect.y c)) (Objet.get_dx o) (Objet.get_dy o)) in
  if Objet.is_flip o then
    match Sdl.render_copy_ex ~dst:rect r (Objet.get_texture o) 0. None Sdl.Flip.horizontal with
    | Error (`Msg e) ->  Sdl.log "Can't fill image error: %s" e; exit 1 
    | Ok () -> ()
  else
    match Sdl.render_copy ~dst:rect r (Objet.get_texture o)  with
    | Error (`Msg e) ->  Sdl.log "Can't fill image error: %s" e; exit 1 
    | Ok () -> ()
;;

let display_background t r c =
  match Sdl.render_copy ~src:c r t  with
  | Error (`Msg e) ->  Sdl.log "Can't fill image error: %s" e; exit 1 
  | Ok () -> ()
;;

let display_user_interface r c p = 
  let offset = ref 15 in
  for i = 1 to (Objet.get_life p) do
    let heart = (Objet.create ((Sdl.Rect.x c) + !offset) ((Sdl.Rect.y c) + 15) (Tool.create_texture_from_image r "images/life.bmp") 0. 0 50 50 0 1000000000 false true true 0 [] false) in
    offset := !offset + 60;
    display_object r c heart
  done;
;;

let display_scene s r c = 
  display_background s.background r c;
  List.iter (display_object r c) (s.gameobjects);
  List.iter (display_object r c) (s.units);
  List.iter (display_object r c) (s.items);
  display_object r c (s.player);
;;

let rec display_buttons bl r = match bl with
  | [] -> ()
  | b::next ->
     let rect = (Sdl.Rect.create (Button.get_x b) (Button.get_y b) (Button.get_dx b) (Button.get_dy b)) in
       match Sdl.render_copy ~dst:rect r (Button.get_texture b)  with
       | Error (`Msg e) ->  Sdl.log "Can't fill image error: %s" e; exit 1 
       | Ok () -> if is_selected b
                  then
                    let ligne = Sdl.Rect.create (Button.get_x b) ((Button.get_y b) + 73) (Button.get_dx b) 5 in
                      Sdl.set_render_draw_color r 249 143 51 0; Sdl.render_fill_rect r (Some ligne); display_buttons next r
                  else display_buttons next r
;;

let display_menu m =
  Sdl.render_clear (Menu.get_renderer m);
  match Sdl.render_copy (Menu.get_renderer m) (Menu.get_bg m)  with
  | Error (`Msg e) ->  Sdl.log "Can't fill image error: %s" e; exit 1 
  | Ok () -> display_buttons (get_button_list m) (Menu.get_renderer m); Sdl.render_present (Menu.get_renderer m)
;;

let display_game s r c =
  Sdl.render_clear r;
  display_scene s r (Camera.get_rect c);
  display_user_interface r (Camera.get_rect c) (Scene.get_player s);
  Sdl.render_present r;
;;

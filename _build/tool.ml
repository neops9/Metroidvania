open Tsdl
open Tsdl_mixer
open Result
open Animation

let create_texture_from_surface r s = match (Sdl.create_texture_from_surface r s) with
  | Error (`Msg e)  -> Sdl.log "Can't create texture error: %s" e; exit 1
  | Ok t -> t
;;

let create_texture_from_image r i = match Sdl.load_bmp i with
  | Error (`Msg e) ->  Sdl.log "Can't load image error: %s" e; exit 1
  | Ok s -> create_texture_from_surface r s
;;

let create_surface_from_image i = match Sdl.load_bmp i with
  | Error (`Msg e) ->  Sdl.log "Can't load image error: %s" e; exit 1
  | Ok s -> s
;;

let get_window_surface w = match (Sdl.get_window_surface w) with
  | Error (`Msg e)  -> Sdl.log "Can't get surface error: %s" e; exit 1
  | Ok r -> r
;;

let scancode s = Sdl.get_scancode_from_key (Sdl.get_key_from_name s) ;;

let load_chunk s = match Mixer.load_wav s with
  | Error (`Msg e) ->  Sdl.log "Can't load sound error: %s" e; exit 1
  | Ok m -> m
;;

let load_music s = match Mixer.load_mus s with
  | Error (`Msg e) ->  Sdl.log "Can't load music error: %s" e; exit 1
  | Ok music -> music
;;

exception No_sound_found ;;
exception No_animation_found ;;

let rec get_sound_from_list l name =
    match l with
    | [] -> raise No_sound_found
    | s::next -> if (Sound.get_name s) = name then s else get_sound_from_list next name
;;

let rec get_animation_from_list l name =
    match l with
    | [] -> raise No_animation_found
    | s::next -> if Animation.get_name s = name then s else get_animation_from_list next name
;;

let rec collision o1 o2 = if Sdl.Rect.h o1 != Sdl.Rect.h o2 && Sdl.Rect.w o1 != Sdl.Rect.w o2 && Sdl.has_intersection o1 o2 then true else false ;;

let rec collision_rec o l =
  match l with
  | [] -> false
  | x::s -> if collision o x then true else collision_rec o s
;;

let dist_2d x1 x2 y1 y2 = sqrt ((((float_of_int x1) -. (float_of_int x2))*.((float_of_int x1) -. (float_of_int x2))) +. (((float_of_int y1) -. (float_of_int y2))*.((float_of_int y1) -. (float_of_int y2)))) ;; 

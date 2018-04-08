open Tsdl
open Result
open Tsdl_mixer

let create_texture_from_surface r s = match (Sdl.create_texture_from_surface r s) with
  | Error (`Msg e)  -> Sdl.log "Can't create texture error : %s" e; exit 1
  | Ok t -> t
;;

let create_texture_from_image r i = match Sdl.load_bmp i with
  | Error (`Msg e) ->  Sdl.log "Cant load image  error: %s" e; exit 1
  | Ok s -> create_texture_from_surface r s
;;

let get_window_surface w = match (Sdl.get_window_surface w) with
  | Error (`Msg e)  -> Sdl.log "Can't get surface error %s" e; exit 1
  | Ok r -> r
;;

let scancode s = Sdl.get_scancode_from_key (Sdl.get_key_from_name s) ;;

let load_chunk s = match Mixer.load_wav s with
  | Error (`Msg e) ->  Sdl.log "Can't load sound error: %s" e; exit 1
  | Ok m -> m
;;

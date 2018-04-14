open Tsdl

type animation = { name : string;
				   dx : int;
                   dy : int; 
                   current_frames : Sdl.texture list; 
                   frames : Sdl.texture list;
                   step : int;
                   timer : int;
                   loop : int }
;;

let create name dx dy frames step loop = { name; dx; dy; current_frames = frames; frames; step; timer = step; loop }

let get_texture a = List.hd a.current_frames ;;
let get_dx a = a.dx ;;
let get_dy a = a.dy ;;
let get_name a = a.name ;;

let update a =
if a.timer = 0 then 
  if a.loop != 0 then
  begin
    match List.tl a.current_frames with
    | [] -> { a with current_frames = a.frames; timer = a.step; loop = if a.loop = (-1) then (-1) else a.loop - 1 }
    | l -> { a with current_frames = l; timer = a.step }
  end
  else a
else
  if a.step = (-1) then a else {a with timer = a.timer - 1 }
;;

let destroy a = List.iter (Sdl.destroy_texture) a.current_frames; List.iter (Sdl.destroy_texture) a.frames ;;

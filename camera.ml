open Tsdl

type camera = { rect : Sdl.rect ; window_width : int; window_height : int } ;;

let create rect window_width window_height = { rect; window_width; window_height } ;;

let move camera scene player =
  Sdl.Rect.set_x camera.rect (((Objet.get_x player) + 50/2) - camera.window_width/2) ;
  
  if (Sdl.Rect.x camera.rect < 0)
  then
    begin
      let save_y = Sdl.Rect.y camera.rect in
      Sdl.Rect.set_x camera.rect 0 ; 
      Sdl.Rect.set_y camera.rect (((Objet.get_y player)) - camera.window_height/2) ; 
      if Sdl.Rect.y camera.rect >= 0
      then
	begin
	  if Sdl.Rect.y camera.rect > (Scene.get_height scene) - (Sdl.Rect.h camera.rect) 
	  then
	    Sdl.Rect.set_y camera.rect ((Scene.get_height scene) - (Sdl.Rect.h camera.rect));
	end
      else
        Sdl.Rect.set_y camera.rect save_y ;
    end
  else
    begin
      if Sdl.Rect.x camera.rect > (Scene.get_width scene) - (Sdl.Rect.w camera.rect)
      then
	begin
	  Sdl.Rect.set_x camera.rect ((Scene.get_width scene) - (Sdl.Rect.w camera.rect)) ;
	  Sdl.Rect.set_y camera.rect (((Objet.get_y player)) - camera.window_height/2) ;
	  if Sdl.Rect.y camera.rect < 0
	  then
	    Sdl.Rect.set_y camera.rect 0
	  else
	    if Sdl.Rect.y camera.rect > (Scene.get_height scene) - (Sdl.Rect.h camera.rect)
	    then Sdl.Rect.set_y camera.rect ((Scene.get_height scene) - (Sdl.Rect.h camera.rect))
	    else ()
	end	  
      else
	begin
	  Sdl.Rect.set_y camera.rect (((Objet.get_y player)) - camera.window_height/2 -50) ;
	  if Sdl.Rect.y camera.rect < 0
	  then
	    Sdl.Rect.set_y camera.rect 0
	  else
	    if Sdl.Rect.y camera.rect > (Scene.get_height scene) - (Sdl.Rect.h camera.rect) then Sdl.Rect.set_y camera.rect ((Scene.get_height scene) - (Sdl.Rect.h camera.rect))
	    else ()
	end
    end
;;

let get_rect camera = camera.rect ;;
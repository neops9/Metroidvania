open Tsdl_mixer
	
type sound

val create : string -> Mixer.chunk -> sound
val get_name : sound -> string
val get_sound : sound -> Mixer.chunk
val play_sound : sound -> unit

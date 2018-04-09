open Tsdl_mixer
	
type music

val create : string -> Mixer.music -> music
val get_name : music -> string
val get_music : music -> Mixer.music
val play_music : music -> unit
val free_music : music -> unit

open Tsdl_mixer

type sound

val create : string -> Mixer.chunk -> sound
val get_nom : sound -> string
val get_music : sound -> Mixer.chunk

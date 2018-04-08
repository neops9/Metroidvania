open Tsdl_mixer

type son

val create : string -> Mixer.chunk -> son
val get_nom : son -> string
val get_music : son -> Mixer.chunk

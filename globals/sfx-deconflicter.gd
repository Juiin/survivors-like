extends Node
## Ensures multiple copies of the same sound don't play simultaneously.
##
## By calling SfxDeconflicter.play() with multiple AudioStreamPlayers, this script monitors when those
## AudioStreamPlayers play to prevent two copies of the same sound from playing simultaneously. This prevents the
## player from hearing one very loud sound effect when several things happen at once.

## Number of milliseconds before the same sound can play a second time.
const DEFAULT_SUPPRESS_SFX_MSEC := 100

## key: (String) audio stream resource path
## value: (int) the amount of time passed in milliseconds between when the engine started and when the sound effect was
## 	last played
var last_played_msec_by_resource_path := {}

var sfx_pairs := {
	"res://Audio/sndEnemyDeath1.mp3": ["res://Audio/sndEnemyDeath2.mp3", "res://Audio/sndEnemyDeath3.mp3"],
	"res://Audio/sndEnemyDeath2.mp3": ["res://Audio/sndEnemyDeath1.mp3", "res://Audio/sndEnemyDeath3.mp3"],
	"res://Audio/sndEnemyDeath3.mp3": ["res://Audio/sndEnemyDeath2.mp3", "res://Audio/sndEnemyDeath1.mp3"]
}

var ignore_sfxs := {
	"res://Audio/SoundEffect/bloody_hit.mp3": true
}

var created_audio_stream_players := {}

# key: (String) audio stream resource path
# value: Dictionary{
# 	"AudioStreamPlayer" : AudioStreamPlayer
# 	"times_played": int
# 	"saved_stream": AudioStream
# }
var saved_audio = {}

## Plays the specified sound effect, unless it was recently played.
##
## Parameters:
## 	'player': The AudioStreamPlayer to play. This is not explicitly typed as an AudioStreamPlayer because it also
## 		supports AudioStreamPlayer2D and AudioStreamPlayer3D nodes.
##
## 	'from_position': The sound effect's start position.
func play(player: Node, from_position: float = 0.0) -> void:
	if not player:
		return
	
	if not player is AudioStreamPlayer \
			and not player is AudioStreamPlayer2D:
		push_warning("Unrecognized AudioStreamPlayer: %s (%s)" % [player.get_path(), player.get_class()])
		return
	
	if not should_play(player):
		# suppress sound effect; sound was played too recently
		player.queue_free()
		pass
	else:
		# play sound effect
		player.play(from_position)

func play_sound(audio: AudioStream, from_pitch: float = 1.0, to_pitch: float = 1.0, volume: float = 1.0) -> void:
	if saved_audio.has(audio.resource_path):
		if saved_audio[audio.resource_path].times_played > 50:
			saved_audio[audio.resource_path].audio_player.stream = saved_audio[audio.resource_path].saved_stream.duplicate()
			saved_audio[audio.resource_path].times_played = 0
		saved_audio[audio.resource_path].times_played += 1
		saved_audio[audio.resource_path].audio_player.play()
	else:
		var audio_player := AudioStreamPlayer.new()
		audio_player.stream = audio
		audio_player.volume_linear = volume # * Game.volume
		audio_player.pitch_scale = randf_range(from_pitch, to_pitch)
		audio_player.max_polyphony = 100
		Engine.get_main_loop().root.add_child(audio_player)
		#created_audio_stream_players[audio.resource_path] = audio_player
		saved_audio[audio.resource_path] = {
			"audio_player": audio_player,
			"times_played": 1,
			"saved_stream": audio.duplicate()
		}
		audio_player.play()


## Returns 'true' if the specified sound effect should play, updating our state to ensure it doesn't play again.
##
## Calling this method results in a state change. It should only be called if the caller wants to play the sound.
##
## Parameters:
## 	'player': The AudioStreamPlayer to play. This is not explicitly typed as an AudioStreamPlayer because it also
## 		supports AudioStreamPlayer2D and AudioStreamPlayer3D nodes.
##
## 	'suppress_sfx_msec': Number of milliseconds before the sound can play a second time.
func should_play(player: Node, suppress_sfx_msec: int = DEFAULT_SUPPRESS_SFX_MSEC) -> bool:
	if not player:
		return false
	
	if not player is AudioStreamPlayer \
			and not player is AudioStreamPlayer2D:
		push_warning("Unrecognized AudioStreamPlayer: %s (%s)" % [player.get_path(), player.get_class()])
		return false
	
	var result := true
	var resource_path: String = player.stream.resource_path
	var last_played_msec: int = last_played_msec_by_resource_path.get(resource_path, 0)
	if last_played_msec + suppress_sfx_msec >= Time.get_ticks_msec():
		# suppress sound effect; sound was played too recently
		result = false
	else:
		# update 'last_played'; sound is about to be played
		last_played_msec_by_resource_path[resource_path] = Time.get_ticks_msec()
	return result

func should_play_path(path: String, suppress_sfx_msec: int = DEFAULT_SUPPRESS_SFX_MSEC) -> bool:
	if ignore_sfxs.has(path):
		return true

	var result := true
	var last_played_msec: int = last_played_msec_by_resource_path.get(path, 0)
	if last_played_msec + suppress_sfx_msec >= Time.get_ticks_msec():
		# suppress sound effect; sound was played too recently
		result = false
	else:
		# update 'last_played'; sound is about to be played
		if sfx_pairs.has(path):
			for pair_path in sfx_pairs[path]:
				last_played_msec_by_resource_path[pair_path] = Time.get_ticks_msec()
		last_played_msec_by_resource_path[path] = Time.get_ticks_msec()
	return result
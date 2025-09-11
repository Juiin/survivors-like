class_name Utils
extends Node

static func get_child_by_class(_node: Node, _class: Variant) -> Node:
	for child in _node.get_children():
		if is_instance_of(child, _class):
			return child
	return null

static func play_audio(audio: AudioStream, from_pitch: float = 1.0, to_pitch: float = 1.0) -> void:
	var audio_player := AudioStreamPlayer2D.new()
	audio_player.stream = audio
	audio_player.pitch_scale = randf_range(from_pitch, to_pitch)
	Engine.get_main_loop().root.add_child(audio_player)
	audio_player.play()
	await audio_player.finished
	audio_player.queue_free()
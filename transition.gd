extends CanvasLayer

@onready var color_rect := $ColorRect

var scene_to_load: String
var color_rect_tween: Tween

func change_scene_to(scene_path: String) -> void:
	if color_rect_tween:
		color_rect_tween.kill()
	Utils.play_audio(preload("res://Audio/swap_to_explosion_2.mp3"), 0.9, 1.1, 0.5)

	scene_to_load = scene_path

	color_rect_tween = create_tween().set_trans(Tween.TRANS_SINE)
	color_rect_tween.tween_property(color_rect.material, "shader_parameter/circle_size", 0.0, 0.4).connect("finished", _load_new_scene)
	color_rect_tween.chain().tween_property(color_rect.material, "shader_parameter/circle_size", 1.05, 0.4)

func _load_new_scene() -> void:
	get_tree().call_deferred("change_scene_to_file", scene_to_load)

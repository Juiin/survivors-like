extends CanvasLayer

@onready var color_rect := $ColorRect

var scene_to_load: String
var color_rect_tween: Tween
var focus_center := false

func change_scene_to(scene_path: String) -> void:
	if color_rect_tween && color_rect_tween.is_running():
		return
	Utils.play_audio(preload("res://Audio/swap_to_explosion_2.mp3"), 0.9, 1.1, 0.5)

	scene_to_load = scene_path
	var focus_pos = get_viewport().get_mouse_position() - color_rect.size * 0.5
	if focus_center:
		focus_pos = get_viewport().get_visible_rect().size * 0.5 - color_rect.size * 0.5
		focus_center = false
	color_rect.global_position = focus_pos

	color_rect_tween = create_tween().set_trans(Tween.TRANS_SINE)
	color_rect_tween.tween_property(color_rect.material, "shader_parameter/circle_size", 0.0, 0.4).connect("finished", _load_new_scene)
	color_rect_tween.chain().tween_property(color_rect.material, "shader_parameter/circle_size", 1.05, 0.4)

func _load_new_scene() -> void:
	get_tree().call_deferred("change_scene_to_file", scene_to_load)

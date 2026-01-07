extends Button


var open_tween: Tween
var close_tween: Tween

var starting_position: Vector2
func _ready() -> void:
	starting_position = global_position
	connect("pressed", return_to_main_menu)

func return_to_main_menu():
	get_tree().paused = false
	Transition.change_scene_to("res://main_menu.tscn")

func open():
	if open_tween && open_tween.is_running():
		return

	show()

	open_tween = create_tween()
	open_tween.tween_property(self, "global_position", global_position + Vector2(0, 155), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func close():
	if close_tween && close_tween.is_running():
		return
	close_tween = create_tween()
	close_tween.tween_property(self, "global_position", starting_position, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
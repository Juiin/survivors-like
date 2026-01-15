extends Button


func _ready() -> void:
	connect("pressed", return_to_main_menu)

func return_to_main_menu():
	get_tree().paused = false
	Transition.change_scene_to("res://main_menu.tscn")

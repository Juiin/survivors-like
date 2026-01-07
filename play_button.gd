extends Button


func _on_pressed() -> void:
	if get_node("%PlayerNameInput").text != "":
		Game.player_name = get_node("%PlayerNameInput").text
	Transition.change_scene_to("res://main.tscn")

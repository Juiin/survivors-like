extends TextureButton


func _on_pressed() -> void:
	#Utils.play_audio(load("res://Audio/play_button.mp3"), 1, 1, 0.2)
	if get_node("%PlayerNameInput").text != "":
		Game.player_name = get_node("%PlayerNameInput").text
	Transition.change_scene_to("res://main.tscn")

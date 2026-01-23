extends CanvasLayer

func _ready() -> void:
	# var player_name = Game.player_name
	# var score: float = 1 / Game.elapsed_time + 1
	# var ldboard_name = "main"
	# var metadata = {
	# 	"elapsed_time": Game.elapsed_time,
	# }
	# SilentWolf.Scores.save_score(player_name, score, ldboard_name, metadata)
	get_tree().paused = true
	Utils.play_audio(load("res://Audio/victory.mp3"))

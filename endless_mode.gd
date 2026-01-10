extends Button


func _ready() -> void:
	connect("pressed", start_endless_mode_animation)

func start_endless_mode_animation():
	%MiscButtons.get_node("Mover").close(start_endless_mode)
	%LeaderboardSubmit.get_node("Mover").close()
	%Victory.get_node("Mover").close()
	%Leaderboard.get_node("Mover").close()

func start_endless_mode():
	get_tree().paused = false
	Game.boss_is_active = false
	owner.queue_free()
extends Button


func _ready() -> void:
	connect("pressed", start_endless_mode)

func start_endless_mode():
	get_tree().paused = false
	Game.boss_is_active = false
	owner.queue_free()
extends Button


func _ready() -> void:
	connect("pressed", Game.toggle_fullscreen)

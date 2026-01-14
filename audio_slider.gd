extends HSlider

func _ready() -> void:
	value = Game.volume
	value_changed.connect(_set_volume)
	_set_volume(Game.volume)

func _set_volume(value: float):
	Game.volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
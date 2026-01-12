extends HSlider

func _ready() -> void:
	value_changed.connect(_set_volume)

func _set_volume(value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
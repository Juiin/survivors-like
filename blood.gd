extends CPUParticles2D

func _ready() -> void:
	Utils.play_audio(load("res://Audio/SoundEffect/bloody_hit.mp3"), 0.9, 1.1)

func _on_timer_timeout() -> void:
	speed_scale = 0

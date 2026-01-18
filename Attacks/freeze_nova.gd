extends Area2D

@onready var cpuparticles_2d: CPUParticles2D = $CPUParticles2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var light := %Light

func _ready() -> void:
	cpuparticles_2d.emitting = true
	var timer = Timer.new()
	timer.set_wait_time(cpuparticles_2d.lifetime)
	timer.set_one_shot(true)
	timer.connect("timeout", queue_free)
	add_child(timer)
	timer.start()
	# Utils.play_audio(preload("res://Audio/sndIceNova.mp3"), 0.9, 1.1, 0.2)
	Utils.play_audio(preload("res://Audio/SoundEffect/ice.wav"), 0.9, 1.1)

	var fade_out_tween = create_tween()
	fade_out_tween.tween_property(light, "modulate:a", 0, cpuparticles_2d.lifetime).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("freeze"):
		body.freeze()

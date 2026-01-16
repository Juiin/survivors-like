extends Sprite2D

const DURATION = 0.5

func _ready() -> void:
	var death_tween = create_tween()
	death_tween.tween_property(material, "shader_parameter/alpha_multiplier", 0, DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	death_tween.tween_callback(queue_free)
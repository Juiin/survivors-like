extends Attack
@onready var sprite := $AnimatedSprite2D

@onready var base_scale := scale
var aoe_increase := 0.0:
	set(value):
		aoe_increase = value
		scale = base_scale * (1 + value)

var sfx = preload("res://Audio/aoe_form_explosion.mp3")

func _ready() -> void:
	Utils.play_audio(sfx, 0.9, 1.1)
	get_tree().get_first_node_in_group("camera").screen_shake(3, 0.1)
	sprite.animation_finished.connect(die)
	position = get_global_mouse_position()


func die() -> void:
	queue_free()
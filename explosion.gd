extends Attack
@onready var sprite := $AnimatedSprite2D

@onready var base_scale := scale
var aoe_increase := 0.0:
	set(value):
		aoe_increase = value
		scale = base_scale * (1 + value)

var apply_burn := true
var burn = preload("res://Attacks/burn_field.tscn")

var sfx = preload("res://Audio/aoe_form_explosion.mp3")

func _ready() -> void:
	aoe_increase = -0.6
	Utils.play_audio(sfx, 0.9, 1.1)
	get_tree().get_first_node_in_group("camera").screen_shake(3, 0.1)
	sprite.animation_finished.connect(die)
	global_position = get_global_mouse_position()

	if apply_burn:
		var inst = burn.instantiate()
		add_child(inst)


func die() -> void:
	queue_free()
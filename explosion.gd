extends Attack
@onready var sprite := $AnimatedSprite2D

var base_scale := scale
var aoe_increase := 0.0:
	set(value):
		aoe_increase = value
		scale = base_scale * (1 + value)

var apply_burn := true
var burn = preload("res://Attacks/burn_field.tscn")

var sfx = preload("res://Audio/aoe_form_explosion.mp3")

var batch_number: int
var offset_distance := 32.0

func _ready() -> void:
	aoe_increase = -0.6
	Utils.play_audio(sfx, 0.9, 1.1, max(0, 0.7 - batch_number * 0.1))
	get_tree().get_first_node_in_group("camera").screen_shake(3, 0.1)
	sprite.animation_finished.connect(die)
	

	if apply_burn:
		var inst = burn.instantiate()
		add_child(inst)


func die() -> void:
	queue_free()

func adjust_position() -> void:
	# global_position = get_global_mouse_position()
	var offset = Vector2.ZERO
	if batch_number > 0:
		var t = clamp((aoe_increase + 0.6) / 1.6, 0.0, 1.0) # map aoe_increase from [-0.6, 1] to [0,1]
		var radius = remap(aoe_increase, -0.6, 1, 32, 64)
		var angle = randf_range(0.0, TAU)
		offset = Vector2(cos(angle), sin(angle)) * radius
	global_position += offset
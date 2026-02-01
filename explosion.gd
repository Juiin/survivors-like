extends Attack
@onready var sprite := $AnimatedSprite2D

var base_scale := scale
var aoe_increase := 0.0:
	set(value):
		aoe_increase = value
		scale = base_scale * (1 + value)
		modulate.a = remap(value, -0.5, 0.1, 1, 0.3)
		modulate.a = clamp(modulate.a, 0.3, 1)

var apply_burn := true
var burn = preload("res://Attacks/burn_field.tscn")

var sfx = load("res://Audio/aoe_form_explosion.mp3")

var batch_number: int
var offset_distance := 32.0

func _ready() -> void:
	aoe_increase = -0.5
	Utils.play_audio(sfx, 0.9, 1.1, max(0, 0.7 - batch_number * 0.1))
	get_tree().get_first_node_in_group("camera").screen_shake(3, 0.1)
	sprite.animation_finished.connect(die)
	
	var fade_out = create_tween()
	fade_out.tween_property(self , "modulate:a", 0, 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD).set_delay(0.25)

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
extends Attack


@onready var sprite := $Sprite2D
const lifetime := 1

var player: Player
var die_tween: Tween

var ice_spear_pierce: int = 1:
	set(new_value):
		ice_spear_pierce = new_value
		hitbox_component.hit_limit = ice_spear_pierce
var ice_spear_base_spd := 200.0
var spd := ice_spear_base_spd
var ice_spear_proj_spd_increase := 0.0:
	set(new_value):
		ice_spear_proj_spd_increase = new_value
		spd = ice_spear_base_spd * (1 + ice_spear_proj_spd_increase)

var return_percent = 0.0
var has_returned := false

var sfx = preload("res://Audio/new_ice_spear.mp3")

func _ready() -> void:
	Utils.play_audio(sfx, 0.7, 0.9)
	get_tree().get_first_node_in_group("camera").screen_shake(3, 0.1)

	player = get_tree().get_first_node_in_group("player")
	position = player.position
	rotation = position.angle_to_point(get_global_mouse_position())

	start_die_tween()

	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.35).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.35).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	
func die() -> void:
	if !has_returned && randf() <= return_percent:
		has_returned = true
		rotation = position.angle_to_point(player.position)
		start_die_tween()
		# hitbox_component.hit_list.clear()
		hitbox_component.hit_count = 0
	else:
		queue_free()
	# var tween = create_tween()
	# tween.tween_property(sprite, "modulate:a", 0, 0.5)
	# tween.tween_callback(queue_free)

func start_die_tween():
	if die_tween: 
		die_tween.kill()

	die_tween = create_tween()
	die_tween.tween_callback(die).set_delay(lifetime)

func _physics_process(delta):
	var dir = Vector2.RIGHT.rotated(rotation)
	position += dir * spd * delta

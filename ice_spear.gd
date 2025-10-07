extends Attack

var ice_spear_pickup := preload("uid://dof70rjknoom5")
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

var drop_percent := 0.0

var batch_number: int
var offset_distance := 20.0
var sfx = preload("res://Audio/new_ice_spear.mp3")

func _ready() -> void:
	Utils.play_audio(sfx, 0.7, 0.9)
	get_tree().get_first_node_in_group("camera").screen_shake(3, 0.1)

	player = get_tree().get_first_node_in_group("player")
	rotation = global_position.angle_to_point(get_global_mouse_position())
	# position = player.position

	# calculate sideways offset (perpendicular to facing direction)
	var right_dir = Vector2.RIGHT.rotated(rotation)
	var perpendicular = right_dir.rotated(deg_to_rad(90)) # i.e. Vector2.UP rotated to match rotation

	# calculate offset amount based on batch_numbers
	# (alternating left/right: 0=center, 1=right, 2=left, 3=more right, 4=more left, etc.)
	var side_multiplier = 0
	if batch_number > 0:
		side_multiplier = ((batch_number + 1) / 2) * (1 if batch_number % 2 == 1 else -1)

	var offset = perpendicular * offset_distance * side_multiplier
	position += offset
	#retarget again so they all converge on the mouse position
	rotation = global_position.angle_to_point(get_global_mouse_position())
	start_die_tween()

	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.35).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.35).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	
func die() -> void:
	if !has_returned && randf() <= return_percent:
		has_returned = true
		rotation = global_position.angle_to_point(player.global_position)
		start_die_tween()
		# hitbox_component.hit_list.clear()
		hitbox_component.hit_count = 0
	else:
		if randf() <= drop_percent:
			var ice_spear = ice_spear_pickup.instantiate()
			ice_spear.global_position = global_position
			get_tree().current_scene.add_child(ice_spear)
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

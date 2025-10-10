extends Node2D

# --- Config ---
var target: Vector2
var fly_duration := 1.5
var max_height := 64.0 # peak of the arc
var shadow_size := Vector2(32, 12)
var shadow_color := Color(0, 0, 0, 0.5)
@onready var sprite_node := $Sprite2D
var shadow_scale_y := 0.35 # flatten the shadow
# --- State ---
var start_position: Vector2
var elapsed := 0.0
var rotating_direction := 1
var marker: Node = null
var z: float

var throw_rock_snd = preload("res://Audio/throw_rock.mp3")
var land_rock_snd = preload("res://Audio/land_rock.mp3")

func _ready() -> void:
	start_position = position
	rotating_direction = [-1, 1].pick_random()
	Utils.play_audio(throw_rock_snd, 0.4, 0.5)
	# Spawn impact marker
	marker = preload("res://Effects/incoming_marker.tscn").instantiate()
	marker.global_position = target
	marker.shape = IncomingMarker.Shape.CIRCLE
	marker.circle_radius = shadow_size.x
	marker.duration = fly_duration
	marker.on_finished = func():
		marker.check_damage()
	get_tree().current_scene.add_child(marker)

func _process(delta: float) -> void:
	elapsed += delta

	# Rotate while flying
	sprite_node.rotate(5.5 * delta * rotating_direction)

	# Progress (0 → 1)
	var t = clamp(elapsed / fly_duration, 0, 1)

	# Horizontal position only
	position = start_position.lerp(target, t)

	# Vertical offset (for visual arc)
	z = -4 * max_height * (t - 0.5) * (t - 0.5) + max_height
	sprite_node.global_position = position + Vector2(0, -z)


	# Redraw shadow
	queue_redraw()

	# End of flight
	if t >= 1.0:
		queue_free()

func _draw() -> void:
	if sprite_node == null or sprite_node.texture == null:
		return

	# Ground position relative to node
	var shadow_pos = Vector2.ZERO

	# Semi-transparent black
	var shadow_color = Color(0, 0, 0, 0.5)

	# Shrink shadow as rock rises
	var t = clamp(elapsed / fly_duration, 0, 1)
	var z = -4 * max_height * (t - 0.5) * (t - 0.5) + max_height
	var scale_factor = 1.0 - (z / max_height) * 0.5

	# Take the sprite's existing scale into account
	var final_scale = Vector2(sprite_node.scale.x, sprite_node.scale.y * shadow_scale_y) * scale_factor

	# Draw the shadow
	draw_texture_rect(
		sprite_node.texture,
		Rect2(shadow_pos - sprite_node.texture.get_size() * 0.5 * final_scale,
			  sprite_node.texture.get_size() * final_scale),
		false,
		shadow_color
	)

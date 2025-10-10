class_name IncomingMarker
extends Node2D

enum Shape {RECTANGLE, CIRCLE}
enum Anchor {TOP, BOTTOM, LEFT, RIGHT}

@export var shape: Shape = Shape.RECTANGLE
@export var anchor: Anchor = Anchor.TOP

@export var rect_size: Vector2 = Vector2(64, 64)
@export var circle_radius: float = 64.0
@export var duration: float = 2.0
@export var color_outline: Color = Color(1, 0.03, 0.03)
@export var color_fill: Color = Color(1, 0.31, 0.24)
@export var color_glow: Color = Color(1, 0.7, 0.5)

var progress := 0.0
var anim_timer := 0.0
var outline_alpha := 1.0
var fill_alpha := 0.5
var ended := false

var on_finished: Callable = func(): pass


# --- Helper function to set alpha manually ---
func color_with_alpha(c: Color, a: float) -> Color:
	return Color(c.r, c.g, c.b, a)
# ---------------------------------------------

func _process(delta: float):
	if not ended:
		progress = clamp(progress + delta / duration, 0.0, 1.0)
		if progress >= 1.0:
			progress = 1.0
			ended = true
			anim_timer = 0.0
			on_finished.call()
	else:
		anim_timer += delta

	queue_redraw()

	# Fade out after finish
	if ended and anim_timer > 0.3 and outline_alpha > 0:
		outline_alpha = lerp(1.0, 0.0, (anim_timer - 0.3) / 0.5)
		fill_alpha = lerp(0.9, 0.0, (anim_timer - 0.3) / 0.5)
		if fill_alpha <= 0 and outline_alpha <= 0:
			queue_free()

func _draw():
	var eased = progress * progress * (3 - 2 * progress)

	match shape:
		Shape.RECTANGLE:
			_draw_rectangle(eased)
		Shape.CIRCLE:
			_draw_circle(eased)

func _draw_rectangle(eased: float):
	var w = rect_size.x
	var h = rect_size.y
	var pos1 := Vector2.ZERO
	var pos2 := Vector2.ZERO

	match anchor:
		Anchor.TOP:
			pos1 = Vector2(-w / 2, 0)
			pos2 = Vector2(w / 2, h)
		Anchor.BOTTOM:
			pos1 = Vector2(-w / 2, -h)
			pos2 = Vector2(w / 2, 0)
		Anchor.LEFT:
			pos1 = Vector2(0, -h / 2)
			pos2 = Vector2(w, h / 2)
		Anchor.RIGHT:
			pos1 = Vector2(-w, -h / 2)
			pos2 = Vector2(0, h / 2)

	# Outline
	draw_rect(Rect2(pos1, pos2 - pos1), color_with_alpha(color_outline, outline_alpha), false, 2.0)

	# Fill (partial)
	var fill_rect := Rect2(pos1, pos2 - pos1)
	match anchor:
		Anchor.TOP:
			fill_rect.size.y *= eased
		Anchor.BOTTOM:
			fill_rect.position.y = pos2.y - h * eased
			fill_rect.size.y = h * eased
		Anchor.LEFT:
			fill_rect.size.x *= eased
		Anchor.RIGHT:
			fill_rect.position.x = pos2.x - w * eased
			fill_rect.size.x = w * eased

	draw_rect(fill_rect, color_with_alpha(color_fill, fill_alpha), true)

	# Flash effect at end
	if ended and anim_timer < 0.3:
		var t = anim_timer / 0.3
		var alpha = 1.0 - t
		var scale = 1.0 + t * 0.3
		var flash_rect = Rect2(pos1 * scale, (pos2 - pos1) * scale)
		draw_rect(flash_rect, Color(1, 1, 1, alpha), true)

func _draw_circle(eased: float):
	var radius = circle_radius
	var fill_r = radius * eased

	# Outline
	draw_circle(Vector2.ZERO, radius, color_with_alpha(color_outline, outline_alpha), false)

	# Fill
	draw_circle(Vector2.ZERO, fill_r, color_with_alpha(color_fill, fill_alpha))

	# Flash
	if ended and anim_timer < 0.3:
		var t = anim_timer / 0.3
		var alpha = 1.0 - t
		var scale = 1.0 + t * 0.5
		draw_circle(Vector2.ZERO, radius * scale, Color(1, 1, 1, alpha))
		
func check_damage():
	const dmg = 5
	var space_state = get_world_2d().direct_space_state

	match shape:
		Shape.CIRCLE:
			var query = PhysicsShapeQueryParameters2D.new()
			var circle_shape = CircleShape2D.new()
			circle_shape.radius = circle_radius
			query.shape = circle_shape
			query.transform = Transform2D(0, global_position)
			query.collision_mask = 1 # set to your player layer mask
			var results = space_state.intersect_shape(query)

			for result in results:
				var collider = result.collider
				if collider.is_in_group("player"):
					collider.health_component.take_damage(dmg) # or your custom damage logic
					get_tree().get_first_node_in_group("camera").screen_shake(10, 0.5)
					Utils.play_audio(preload("res://Audio/hurt.mp3"), 0.95, 1.05)
					var dmg_color = Color.RED
					Effects.spawn_damage_text(dmg, collider.global_position, dmg_color)

		Shape.RECTANGLE:
			var query = PhysicsShapeQueryParameters2D.new()
			var rect_shape = RectangleShape2D.new()
			rect_shape.extents = rect_size / 2.0
			query.shape = rect_shape
			query.transform = Transform2D(0, global_position)
			query.collision_mask = 1 # adjust mask
			var results = space_state.intersect_shape(query)

			for result in results:
				var collider = result.collider
				if collider.is_in_group("player"):
					collider.health_component.take_damage(dmg) # or your custom damage logic
					get_tree().get_first_node_in_group("camera").screen_shake(10, 0.5)
					Utils.play_audio(preload("res://Audio/hurt.mp3"), 0.95, 1.05)
					var dmg_color = Color.RED
					Effects.spawn_damage_text(dmg, collider.global_position, dmg_color)

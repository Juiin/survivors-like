extends Node2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	global_position = get_global_mouse_position()

func _physics_process(delta: float) -> void:
	global_position = get_global_mouse_position()

	var desired_rotation := -12.5 if Input.is_action_pressed("click") else 0.0
	rotation_degrees = lerp(rotation_degrees, desired_rotation, 16.5 * delta)

	var desired_scale := Vector2(1, 1.35) if Input.is_action_pressed("click") else Vector2(1.4, 1.4)
	scale = lerp(scale, desired_scale, 16.5 * delta)

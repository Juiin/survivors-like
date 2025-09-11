extends Area2D

@onready var spd := 200.0
@onready var sprite := $Sprite2D

const lifetime := 1

var sfx = preload("res://Audio/new_ice_spear.mp3")

func _ready() -> void:
	print("ice_spear")
	Utils.play_audio(sfx, 0.7, 0.9)
	get_tree().get_first_node_in_group("camera").screen_shake(3, 0.1)

	var player = get_tree().get_first_node_in_group("player")
	position = player.position
	rotation = position.angle_to_point(get_global_mouse_position())

	create_tween().tween_callback(die).set_delay(lifetime)

	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.35).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.35).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	
func die() -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0, 0.5)
	tween.tween_callback(queue_free)

func _physics_process(delta):
	var dir = Vector2.RIGHT.rotated(rotation)
	position += dir * spd * delta

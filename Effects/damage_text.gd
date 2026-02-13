class_name DamageText extends Node2D

@onready var label: RichTextLabel = $Label

var travel_distance: Vector2 = Vector2(15, -20)

var pos: Vector2
var text: String
var color = Color.WHITE
var dur: float = 2.5

func _ready() -> void:
	global_position = pos
	label.text = text
	label.modulate = color

	travel_distance.x *= randf_range(-1, 1)
	travel_distance.y *= randf_range(1, 2)
	
	var tween: Tween = create_tween().set_parallel()
	tween.tween_property(self , "global_position", global_position + travel_distance, dur / 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self , "modulate:a", 0, dur / 2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.chain().tween_callback(queue_free)

func _process(delta: float) -> void:
	pass

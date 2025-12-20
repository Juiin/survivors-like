class_name Hints
extends PanelContainer

@onready var label := %HintLabel
@export var hint_database: HintDatabase

var open_tween: Tween
var close_tween: Tween

var starting_position: Vector2
func _ready() -> void:
	starting_position = global_position
	

func open():
	if open_tween && open_tween.is_running():
		return
	show()
	label.text = hint_database.hints[randi_range(0, hint_database.hints.size() - 1)]
	#reset_size()
	open_tween = create_tween()
	open_tween.tween_property(self, "global_position", global_position - Vector2(0, 75), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func close():
	if close_tween && close_tween.is_running():
		return
	close_tween = create_tween()
	close_tween.tween_property(self, "global_position", starting_position, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	close_tween.tween_callback(hide)

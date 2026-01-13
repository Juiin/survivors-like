class_name Hints
extends PanelContainer

@onready var label := %HintLabel
@export var hint_database: HintDatabase

var open_tween: Tween
var close_tween: Tween

var local_hints := []

var starting_position: Vector2
func _ready() -> void:
	starting_position = global_position
	local_hints = hint_database.hints.duplicate()

func open():
	if open_tween && open_tween.is_running():
		return
	show()

	var chosen_hint = local_hints.pick_random()
	local_hints.erase(chosen_hint)
	label.text = chosen_hint

	if local_hints.size() == 0:
		local_hints = hint_database.hints.duplicate()

	#reset_size()
	open_tween = create_tween()
	open_tween.tween_property(self, "global_position", global_position - Vector2(0, 75), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func close():
	if close_tween && close_tween.is_running():
		return
	close_tween = create_tween()
	close_tween.tween_property(self, "global_position", starting_position, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	close_tween.tween_callback(hide)

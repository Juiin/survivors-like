class_name Mover
extends Node2D

# @export var to_move_node: Node
@onready var to_move_node := get_parent()

var final_pos: Vector2
var start_pos: Vector2
var open_tween: Tween
var close_tween: Tween


@export var auto_open := true

func _ready():
	start_pos = global_position
	final_pos = to_move_node.global_position
	to_move_node.global_position = start_pos
	if auto_open:
		open()
	else:
		close()

func open():
	if open_tween && open_tween.is_running():
		return

	show()
	open_tween = create_tween()
	open_tween.tween_property(to_move_node, "global_position", final_pos, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func close(callback=func(): pass ):
	if close_tween && close_tween.is_running():
		return
	close_tween = create_tween()
	close_tween.tween_property(to_move_node, "global_position", start_pos, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	close_tween.tween_callback(hide)
	close_tween.tween_callback(callback)

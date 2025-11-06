class_name ElapsedGameTimer
extends Panel

@onready var label := $Label

var open_tween: Tween
var close_tween: Tween

var starting_position: Vector2
func _ready() -> void:
	starting_position = global_position
	

func open():
	if open_tween && open_tween.is_running():
		return

	show()
	label.text = format_time(Game.elapsed_time)
   
	open_tween = create_tween()
	open_tween.tween_property(self, "global_position", global_position - Vector2(0, 75), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func close(callback):
	if close_tween && close_tween.is_running():
		return
	close_tween = create_tween()
	close_tween.tween_property(self, "global_position", starting_position, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	close_tween.tween_callback(hide)
	close_tween.tween_callback(callback)

func format_time(seconds: float) -> String:
	var total_seconds = int(seconds)
	var minutes = total_seconds / 60
	var secs = total_seconds % 60
	var millis = int((seconds - total_seconds) * 100)
	return "%02d:%02d.%02d" % [minutes, secs, millis]
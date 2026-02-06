class_name CustomHealthBar
extends ProgressBar

var change_value_tween: Tween
var opacity_tween: Tween
@export var health_component: HealthComponent
@export var white_catchup_time := 0.5

func _ready() -> void:
	modulate.a = 0.0
	max_value = health_component.max_health
	value = health_component.max_health
	$ProgressBar.max_value = health_component.max_health
	$ProgressBar.value = health_component.max_health

	health_component.health_changed.connect(change_value)

func change_value():
	if health_component.health < health_component.max_health:
		_change_opacity(1.0)
	else:
		_change_opacity(0.0)
	max_value = health_component.max_health
	$ProgressBar.max_value = health_component.max_health
	value = health_component.health

	if change_value_tween:
		change_value_tween.kill()
	change_value_tween = create_tween()
	#change_value_tween.finished.connect($ResetVisibility.start)
	change_value_tween.tween_property($ProgressBar, "value", health_component.health, white_catchup_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _change_opacity(new_amount: float):
	if opacity_tween:
		opacity_tween.kill()
	opacity_tween = create_tween()
	opacity_tween.tween_property(self , "modulate:a", new_amount, 0.12).set_trans(Tween.TRANS_SINE)

func _on_reset_visibility_timeout() -> void:
	_change_opacity(0.0)

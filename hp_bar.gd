extends ProgressBar

@export var health_component: HealthComponent

func _ready() -> void:
	max_value = health_component.max_health
	value = max_value
	health_component.connect("health_changed", update_value)

func update_value() -> void:
	max_value = health_component.max_health
	value = health_component.health

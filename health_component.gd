class_name HealthComponent
extends Node

@export var max_health := 100.0
var health: float

signal health_changed
signal died
signal took_damage

func _ready():
    health = max_health
    health_changed.emit()

func take_damage(damage: float):
    if damage <= 0:
        return

    health -= damage
    health_changed.emit()
    took_damage.emit()
    if health <= 0:
        died.emit()
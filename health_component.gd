class_name HealthComponent
extends Node

@export var max_health := 100.0: set = _set_max_health
var health: float

signal health_changed
signal died
signal took_damage

func _set_max_health(value: float):
    # var percent_hp = health / max_health
    # max_health = value
    # health = max_health * percent_hp
    max_health = value
    health = value
    health_changed.emit()

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

func heal(amount: float):
    amount = min(amount, max_health - health)
    health += amount
    
    Effects.spawn_damage_text(amount, owner.global_position, Color.GREEN)
    health_changed.emit()
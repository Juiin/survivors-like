class_name Stats
extends Resource

@export var max_health := 100.0
var health: float

func _init() -> void:
    health = max_health

func take_damage(amount):
    health -= amount

func create_instance() -> Resource:
    var instance: Stats = self.duplicate()
    instance.health = max_health
    return instance
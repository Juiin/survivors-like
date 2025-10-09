class_name Stats
extends Resource

@export var max_health := 100.0
@export var sprite: SpriteFrames
@export var type: Enums.UpgradeType
@export var drop_value: int
@export var spd: float = 50
@export var knockback_recovery := 3.5
@export var health_drop_chance := 0
var health: float


func create_instance() -> Resource:
    var instance: Stats = self.duplicate()
    instance.health = max_health
    instance.sprite = sprite
    instance.type = type
    instance.drop_value = drop_value
    return instance
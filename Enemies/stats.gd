class_name Stats
extends Resource

@export var max_health := 100.0
@export var sprite: SpriteFrames
@export var type: Enums.UpgradeType
@export var drop_value: int
var health: float


func create_instance() -> Resource:
    var instance: Stats = self.duplicate()
    instance.health = max_health
    instance.sprite = sprite
    instance.type = type
    instance.drop_value = drop_value
    return instance
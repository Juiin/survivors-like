class_name KnockbackUpgrade
extends Upgrade

var increase := 50.0


func _init(_type: Enums.UpgradeType):
    upgrade_name = "Knockback"
    upgrade_description = "Increases the strength by which enemies are knocked back on hit"
    cost = [10, 100, 200, 400]
    type = _type

func apply_upgrade(attack: Attack) -> void:
    attack.hitbox_component.knockback_amount += increase

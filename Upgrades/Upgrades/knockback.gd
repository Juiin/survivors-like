class_name KnockbackUpgrade
extends Upgrade

var increase := 50.0


func _init(_type: Enums.UpgradeType):
    upgrade_name = "Knockback"
    upgrade_description = "Increases the strength by which enemies are knocked back on hit"
    cost = [10, 200, 350, 600]
    type = _type

func apply_upgrade(attack: Attack) -> void:
    attack.hitbox_component.knockback_amount += increase

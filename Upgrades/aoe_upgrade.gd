class_name AoeUpgrade
extends Upgrade

@export var aoe_increase := 0.1

func apply_upgrade(attack: Attack) -> void:
    attack.aoe_increase += aoe_increase

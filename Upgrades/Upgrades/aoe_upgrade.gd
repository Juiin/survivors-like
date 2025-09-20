class_name AoeUpgrade
extends Upgrade

@export var aoe_increase := 0.1


func _init():
    upgrade_name = "AoE Increase"
    upgrade_description = "Increased Area of Effect"
    cost = [15, 20, 25, 30, 35, 40, 45, 50]
    type = Enums.UpgradeType.EXPLOSION

func apply_upgrade(attack: Attack) -> void:
    attack.aoe_increase += aoe_increase

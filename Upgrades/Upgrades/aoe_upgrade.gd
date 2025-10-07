class_name AoeUpgrade
extends Upgrade

@export var aoe_increase := 0.1


func _init():
    upgrade_name = "AoE Increase"
    upgrade_description = "Increased Area of Effect"
    cost = [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000]
    type = Enums.UpgradeType.EXPLOSION
    endless = true

func apply_upgrade(attack: Attack) -> void:
    attack.aoe_increase += aoe_increase

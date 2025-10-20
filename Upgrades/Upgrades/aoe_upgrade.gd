class_name AoeUpgrade
extends Upgrade

@export var aoe_increase := 0.15


func _init():
    upgrade_name = "AoE Increase"
    upgrade_description = "Increased Area of Effect"
    cost = [50, 100, 150, 200, 250, 300, 350, 400, 450, 500]
    type = Enums.UpgradeType.EXPLOSION
    endless = true

func apply_upgrade(attack: Attack) -> void:
    attack.aoe_increase += aoe_increase

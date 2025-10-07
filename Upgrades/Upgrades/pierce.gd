class_name PierceUpgrade
extends Upgrade

@export var increase := 1


func _init():
    upgrade_name = "Pierce"
    upgrade_description = "Ice Spears pierce an additional target"
    cost = [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000]
    type = Enums.UpgradeType.ICE_SPEAR
    endless = true

func apply_upgrade(attack: Attack) -> void:
    attack.ice_spear_pierce += increase

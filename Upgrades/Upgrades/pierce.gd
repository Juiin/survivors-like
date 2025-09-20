class_name PierceUpgrade
extends Upgrade

@export var increase := 1


func _init():
    upgrade_name = "Pierce"
    upgrade_description = "Ice Spears pierce an additional target"
    cost = [15, 20, 25, 30, 35, 40, 45, 50]
    type = Enums.UpgradeType.ICE_SPEAR

func apply_upgrade(attack: Attack) -> void:
    attack.ice_spear_pierce += increase

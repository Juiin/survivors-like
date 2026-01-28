class_name PierceUpgrade
extends Upgrade

@export var increase := 1


func _init():
    upgrade_name = "Pierce"
    upgrade_description = "Ice Spears and Ice Shards pierce an additional target"
    cost = [50, 75, 100, 125, 150, 175, 200, 225, 250]
    type = Enums.UpgradeType.ICE_SPEAR
    endless = true

func apply_upgrade(attack: Attack) -> void:
    attack.ice_spear_pierce += increase

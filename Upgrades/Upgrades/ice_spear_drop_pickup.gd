class_name IceSpearDropPickupUpgrade
extends Upgrade

@export var increase := 0.10


func _init():
    upgrade_name = "Pickupable Ice Spear"
    upgrade_description = "+10% Chance for Ice Spears to leave behind a pickupable Ice Spear"
    cost = [15, 20, 25, 30, 35]
    type = Enums.UpgradeType.ICE_SPEAR

func apply_upgrade(attack: Attack) -> void:
    attack.drop_percent += increase

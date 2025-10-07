class_name IceSpearDropPickupUpgrade
extends Upgrade

@export var increase := 0.10


func _init():
    upgrade_name = "Pickupable Ice Spear"
    upgrade_description = "+10% Chance for Ice Spears to leave behind a pickupable Ice Spear"
    cost = [250, 500, 750, 1000, 1250, 1500, 1750, 2000, 2250, 2500]
    type = Enums.UpgradeType.ICE_SPEAR

func apply_upgrade(attack: Attack) -> void:
    attack.drop_percent += increase

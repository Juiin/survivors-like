class_name IceSpearDropPickupUpgrade
extends Upgrade

@export var increase := 0.10

func _init():
    upgrade_name = "Pickupable Ice Spear"
    upgrade_description = "+10% Chance for Ice Spears to leave behind a pickupable Ice Spear"
    cost = [50, 100, 150, 250, 350, 500, 700, 800, 900, 1000]
    type = Enums.UpgradeType.ICE_SPEAR

func apply_upgrade(attack: Attack) -> void:
    attack.drop_percent += increase

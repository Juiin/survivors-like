class_name ReturnUpgrade
extends Upgrade

@export var increase := 0.25


func _init():
    upgrade_name = "Projectile Return"
    upgrade_description = "+25% Chance for Ice Spears to return to you"
    cost = [300, 600, 1000, 1500]
    type = Enums.UpgradeType.ICE_SPEAR

func apply_upgrade(attack: Attack) -> void:
    attack.return_percent += increase

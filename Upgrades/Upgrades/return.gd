class_name ReturnUpgrade
extends Upgrade

@export var increase := 0.1


func _init():
    upgrade_name = "Projectile Return"
    upgrade_description = "+10% Chance for Ice Spears to return to you"
    cost = [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000]
    type = Enums.UpgradeType.ICE_SPEAR

func apply_upgrade(attack: Attack) -> void:
    attack.return_percent += increase

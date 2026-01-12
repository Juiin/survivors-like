class_name ReturnUpgrade
extends Upgrade

@export var increase := 0.1


func _init():
    upgrade_name = "Projectile Return"
    upgrade_description = "+10% Chance for Ice Spears to return to you"
    cost = [100, 150, 200, 250, 300, 350, 400, 450, 500, 600]
    type = Enums.UpgradeType.ICE_SPEAR

func apply_upgrade(attack: Attack) -> void:
    attack.return_percent += increase

class_name ProjSpdUpgrade
extends Upgrade

@export var increase := 0.25


func _init():
    upgrade_name = "Projectile Speed"
    upgrade_description = "Ice Spears fly 25% faster"
    cost = [15, 20, 25, 30, 35, 40, 45, 50]
    type = Enums.UpgradeType.ICE_SPEAR

func apply_upgrade(attack: Attack) -> void:
    attack.ice_spear_proj_spd_increase += increase

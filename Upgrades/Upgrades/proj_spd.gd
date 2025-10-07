class_name ProjSpdUpgrade
extends Upgrade

@export var increase := 0.25


func _init():
    upgrade_name = "Projectile Speed"
    upgrade_description = "Ice Spears fly 25% faster"
    cost = [50, 100, 150, 200, 250, 300, 350, 400, 450, 500]
    type = Enums.UpgradeType.ICE_SPEAR
    endless = true

func apply_upgrade(attack: Attack) -> void:
    attack.ice_spear_proj_spd_increase += increase

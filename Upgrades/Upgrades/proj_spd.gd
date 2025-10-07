class_name ProjSpdUpgrade
extends Upgrade

@export var increase := 0.25


func _init():
    upgrade_name = "Projectile Speed"
    upgrade_description = "Ice Spears fly 25% faster"
    cost = [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000]
    type = Enums.UpgradeType.ICE_SPEAR
    endless = true

func apply_upgrade(attack: Attack) -> void:
    attack.ice_spear_proj_spd_increase += increase

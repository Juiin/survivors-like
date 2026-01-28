class_name IceSpearProjectilesUpgrade
extends Upgrade

@export var increase := 1

func _init():
    upgrade_name = "Additional Ice Spear"
    upgrade_description = "Fire an additional Ice Spear every time you cast"
    cost = [500, 1500, 2500, 3500, 5000, 7500, 10000, 12500, 15000]
    type = Enums.UpgradeType.ICE_SPEAR

func apply_player_upgrade(player: Player) -> void:
    player.ice_spear_projectiles += increase

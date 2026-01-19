class_name IceSpearProjectilesUpgrade
extends Upgrade

@export var increase := 1

func _init():
    upgrade_name = "Additional Ice Spears"
    upgrade_description = "Ice Spear fires an additional projectile"
    cost = [500, 2000, 3000, 5000, 8000, 10000, 12500, 15000, 20000]
    type = Enums.UpgradeType.ICE_SPEAR

func apply_player_upgrade(player: Player) -> void:
    player.ice_spear_projectiles += increase

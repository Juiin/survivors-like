class_name IceSpearProjectilesUpgrade
extends Upgrade

@export var increase := 1

func _init():
    upgrade_name = "Additional Projectiles"
    upgrade_description = "Ice Spear fires an additional projectile"
    cost = [500, 750, 1000, 1250, 1500, 1750, 2000, 2250, 2500]
    type = Enums.UpgradeType.ICE_SPEAR

func apply_player_upgrade(player: Player) -> void:
    player.ice_spear_projectiles += increase

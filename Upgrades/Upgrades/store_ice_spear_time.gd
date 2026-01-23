class_name StoreIceSpearTimeUpgrade
extends Upgrade

@export var increase := 0.1


func _init():
    upgrade_name = "Faster Store Time"
    upgrade_description = "Store a new Ice Spear 10% faster"
    cost = [150, 250, 300, 400, 500, 600]
    type = Enums.UpgradeType.ICE_SPEAR

func apply_player_upgrade(player: Player) -> void:
    player.increased_ice_spear_store_time += increase
    player.ice_spear_store_time = player.base_ice_spear_store_time / (1.0 + player.increased_ice_spear_store_time)

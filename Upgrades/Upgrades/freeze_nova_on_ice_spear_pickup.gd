class_name FreezeNovaOnPickupUpgrade
extends Upgrade

func _init(_req_upgrade: Upgrade):
    upgrade_name = "Freeze on Pickup"
    upgrade_description = "Erupt a freezing Nova when picking up an Ice Spear"
    cost = [500]
    type = Enums.UpgradeType.ICE_SPEAR
    req_upgrade = _req_upgrade


func apply_player_upgrade(player: Player) -> void:
    player.freeze_nova_on_pickup = true
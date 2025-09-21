class_name MaxStoredIceSpearsUpgrade
extends Upgrade

@export var increase := 1


func _init():
    upgrade_name = "Stored Ice Spears"
    upgrade_description = "+1 to maximum number of Ice Spears you can store"
    cost = [15, 20, 25, 30, 35, 40, 45, 50]
    type = Enums.UpgradeType.ICE_SPEAR

func apply_player_upgrade(player: Player) -> void:
    player.max_ice_spear_stored += increase

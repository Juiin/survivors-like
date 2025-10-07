class_name MaxStoredIceSpearsUpgrade
extends Upgrade

@export var increase := 1


func _init():
    upgrade_name = "Stored Ice Spears"
    upgrade_description = "+1 to maximum number of Ice Spears you can store"
    cost = [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000]
    type = Enums.UpgradeType.ICE_SPEAR
    endless = true

func apply_player_upgrade(player: Player) -> void:
    player.max_ice_spear_stored += increase

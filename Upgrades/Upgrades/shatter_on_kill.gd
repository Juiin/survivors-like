class_name ShatterOnKillUpgrade
extends Upgrade

@export var increase := 0.1

func _init():
    upgrade_name = "Shatter on Kill"
    upgrade_description = "10% chance for frozen enemies to shatter into 5 ice shards on kill, dealing 5 damage each"
    cost = [100, 250, 450, 650, 850, 1200, 1500, 1800, 2000, 2500]
    type = Enums.UpgradeType.ICE_SPEAR
    #req_upgrade = _req_upgrade

func apply_player_upgrade(player: Player) -> void:
    Game.shatter_on_kill += increase

class_name ShatterOnKillUpgrade
extends Upgrade

@export var increase := 0.1

func _init():
    upgrade_name = "Shatter on Kill"
    upgrade_description = "10% chance for frozen enemies to shatter into 5 ice shards on kill, dealing 10 damage each"
    cost = [50, 100, 150, 200, 250, 300, 350, 400, 450, 500]
    type = Enums.UpgradeType.ICE_SPEAR
    #req_upgrade = _req_upgrade

func apply_player_upgrade(player: Player) -> void:
    Game.shatter_on_kill += increase

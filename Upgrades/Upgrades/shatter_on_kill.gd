class_name ShatterOnKillUpgrade
extends Upgrade

@export var increase := 0.1

func _init():
    upgrade_name = "Shatter on Kill"
    upgrade_description = "10% chance for [url][color=#7fd4ff]frozen[/color][/url] enemies to shatter into 5 ice shards on kill, dealing 5 damage each"
    cost = [100, 150, 250, 400, 600, 800, 1000, 1250, 1500, 1750]
    type = Enums.UpgradeType.ICE_SPEAR
    #req_upgrade = _req_upgrade
    has_freeze_hint = true

func apply_player_upgrade(player: Player) -> void:
    Game.shatter_on_kill += increase

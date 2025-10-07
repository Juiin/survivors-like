class_name GlobalLootUpgrade
extends Upgrade

var loot_multi_increase := 0.5
var enemy_multi_increase := 0.3


func _init():
	upgrade_name = "Risky Loot"
	upgrade_description = "Monsters have 30% more Health and drop 50% more Gems"
	cost = [10, 100, 150, 200, 250, 300, 350, 400, 500]
	type = Enums.UpgradeType.GLOBAL

func apply_player_upgrade(player: Player) -> void:
	Game.money_multi += loot_multi_increase
	Game.enemy_health_multi += enemy_multi_increase

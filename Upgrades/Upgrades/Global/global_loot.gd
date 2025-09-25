class_name GlobalLootUpgrade
extends Upgrade

var loot_multi_increase := 0.3
var enemy_multi_increase := 0.5


func _init():
	upgrade_name = "Risky Loot"
	upgrade_description = "Monsters have 50% more Health and drop 30% more Gems"
	cost = [5, 10, 15, 20, 25, 30, 35, 1, 1, 10]
	type = Enums.UpgradeType.GLOBAL

func apply_player_upgrade(player: Player) -> void:
	Game.money_multi += loot_multi_increase
	Game.enemy_health_multi += enemy_multi_increase

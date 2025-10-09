class_name GlobalLootUpgrade
extends Upgrade

var loot_multi_increase := 0.1
var enemy_multi_increase := 0.1


func _init():
	upgrade_name = "Difficulty Up"
	upgrade_description = "Monsters have 10% more Health and drop 10% more Gems"
	cost = [10, 25, 50, 75, 100, 125, 150, 175, 200]
	type = Enums.UpgradeType.GLOBAL

func apply_player_upgrade(player: Player) -> void:
	Game.money_multi += loot_multi_increase
	Game.enemy_health_multi += enemy_multi_increase

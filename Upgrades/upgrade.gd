class_name Upgrade
extends Resource

var upgrade_name: String = "Upgrade Name"
var upgrade_description: String = "Upgrade Description %s"
var locked_description: String = "Unlock by upgrading the upgrade directly above"
var cost: Array[int] = [10]
var level := 0:
	get: return min(level, cost.size() - 1)
	set(value):
		level = min(value, cost.size() - 1)
var req_upgrade: Upgrade = null
var req_upgrade_level := 1
var endless = false;
var times_upgraded := 0
var charged_sprite: Texture2D

var type: Enums.UpgradeType

func apply_upgrade(attack: Attack) -> void:
	pass

func apply_player_upgrade(player: Player) -> void:
	pass

func create_instance() -> Resource:
	var instance: Upgrade = self.duplicate()
	instance.level = level
	return instance

func is_unlocked() -> bool:
	return !req_upgrade || req_upgrade.times_upgraded >= req_upgrade_level

func is_buyable() -> bool:
	if level > cost.size() - 1:
		return false

	return is_unlocked() && Game.enough_upgrade_cost(type, cost[level])

extends Node

var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

signal ice_spear_money_changed
signal explosion_money_changed

var ice_spear_money: int = 22:
	set(new_value):
		ice_spear_money = max(new_value, 0)
		ice_spear_money_changed.emit()
var explosion_money: int = 12:
	set(new_value):
		explosion_money = max(new_value, 0)
		explosion_money_changed.emit()

func enough_upgrade_cost(type: Enums.UpgradeType, amount: int):
	match type:
		Enums.UpgradeType.ICE_SPEAR:
			return ice_spear_money >= amount
		Enums.UpgradeType.EXPLOSION:
			return explosion_money >= amount

	return false

func adjust_money(type: Enums.UpgradeType, amount: int):
	match type:
		Enums.UpgradeType.ICE_SPEAR:
			ice_spear_money += amount
		Enums.UpgradeType.EXPLOSION:
			explosion_money += amount

func add_upgrade_to_player(type: Enums.UpgradeType, upgrade: Upgrade):
	match type:
		Enums.UpgradeType.ICE_SPEAR:
			player.ice_spear_upgrades.append(upgrade)
		Enums.UpgradeType.EXPLOSION:
			player.explosion_upgrades.append(upgrade)
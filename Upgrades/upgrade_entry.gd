class_name UpgradeEntry
extends PanelContainer

var upgrade: Upgrade

func _ready() -> void:
	%UpgradeName.text = upgrade.upgrade_name
	%UpgradeDescription.text = upgrade.upgrade_description
	%BuyButton.text = str(upgrade.cost)
	update_button_status()
	match upgrade.type:
		Enums.UpgradeType.ICE_SPEAR:
			Game.ice_spear_money_changed.connect(update_button_status)
		Enums.UpgradeType.EXPLOSION:
			Game.explosion_money_changed.connect(update_button_status)

func _on_buy_button_pressed() -> void:
	if Game.enough_upgrade_cost(upgrade.type, upgrade.cost):
		Game.adjust_money(upgrade.type, -upgrade.cost)
		Game.add_upgrade_to_player(upgrade.type, upgrade)
		queue_free()

func update_button_status():
	%BuyButton.disabled = !Game.enough_upgrade_cost(upgrade.type, upgrade.cost)
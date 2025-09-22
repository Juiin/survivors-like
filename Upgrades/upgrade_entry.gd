class_name UpgradeEntry
extends PanelContainer

var upgrade_array: Array[Upgrade]
var upgrade_index: int

var upgrade: Upgrade

func _ready() -> void:
	upgrade = upgrade_array[upgrade_index]

	%UpgradeName.text = upgrade.upgrade_name
	%UpgradeDescription.text = upgrade.upgrade_description
	print("upgrade: ", upgrade)
	print("upgrade.level: ", upgrade.level)
	%BuyButton.text = str(upgrade.cost[upgrade.level])
	match upgrade.type:
		Enums.UpgradeType.ICE_SPEAR:
			%BuyButton.icon = preload("res://Textures/Items/Gems/Gem_blue.png")
		Enums.UpgradeType.EXPLOSION:
			%BuyButton.icon = preload("res://Textures/Items/Gems/Gem_red.png")
		Enums.UpgradeType.GLOBAL:
			%BuyButton.icon = preload("res://Textures/Items/Gems/Gem_blue_red.png")

	update_button_status()
	
	Game.ice_spear_money_changed.connect(update_button_status)
	Game.explosion_money_changed.connect(update_button_status)

func _on_buy_button_pressed() -> void:
	if Game.enough_upgrade_cost(upgrade.type, upgrade.cost[upgrade.level]):
		Game.adjust_money(upgrade.type, -upgrade.cost[upgrade.level])
		Game.add_upgrade_to_player(upgrade.type, upgrade)
		Utils.play_audio(preload("res://Audio/purchase.ogg"), 0.9, 1.1)
		upgrade.level += 1
		if upgrade.level > upgrade.cost.size() - 1:
			# upgrade_array.remove_at(upgrade_index)
			queue_free()
		else:
			%BuyButton.text = str(upgrade.cost[upgrade.level])

func update_button_status():
	%BuyButton.disabled = !Game.enough_upgrade_cost(upgrade.type, upgrade.cost[upgrade.level])
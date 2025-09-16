class_name UI_root
extends CanvasLayer

@onready var ice_spear_upgrade_menu := %UpgradeMenuIceSpear
@onready var explosion_upgrade_menu := %UpgradeMenuExplosion

var ice_spear_upgrades : Array[Upgrade] = [
	FlatDamageUpgrade.new(),
]
var explosion_upgrades : Array[Upgrade] = [
	AoeUpgrade.new()
]

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		if ice_spear_upgrade_menu.visible:
			ice_spear_upgrade_menu.close()
			explosion_upgrade_menu.close()
		else:
			ice_spear_upgrade_menu.open( ice_spear_upgrades)
			explosion_upgrade_menu.open( explosion_upgrades)
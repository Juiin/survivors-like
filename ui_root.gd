class_name UI_root
extends CanvasLayer

@onready var ice_spear_upgrade_menu := %UpgradeMenuIceSpear
@onready var explosion_upgrade_menu := %UpgradeMenuExplosion
@onready var global_upgrade_menu := %UpgradeMenuGlobal

var ice_spear_upgrades: Array[Upgrade] = [
	FlatDamageUpgrade.new(Enums.UpgradeType.ICE_SPEAR),
	ProjSpdUpgrade.new(),
	PierceUpgrade.new(),
	ReturnUpgrade.new(),
]
var explosion_upgrades: Array[Upgrade] = [
	FlatDamageUpgrade.new(Enums.UpgradeType.EXPLOSION),
	AoeUpgrade.new(),
	GlobalAtkSpdUpgrade.new(),
	GlobalAtkSpdUpgrade.new(),
	GlobalAtkSpdUpgrade.new(),
	GlobalAtkSpdUpgrade.new(),
	GlobalAtkSpdUpgrade.new(),
	GlobalAtkSpdUpgrade.new(),
	GlobalAtkSpdUpgrade.new(),
]
var global_upgrades: Array[Upgrade] = [
	GlobalPickupRadius.new(),
	GlobalAtkSpdUpgrade.new(),
	GlobalLootUpgrade.new()
	
]

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		if ice_spear_upgrade_menu.visible:
			ice_spear_upgrade_menu.close()
			explosion_upgrade_menu.close()
			global_upgrade_menu.close()
			get_tree().paused = false
		else:
			ice_spear_upgrade_menu.open(ice_spear_upgrades)
			explosion_upgrade_menu.open(explosion_upgrades)
			global_upgrade_menu.open(global_upgrades)
			get_tree().paused = true
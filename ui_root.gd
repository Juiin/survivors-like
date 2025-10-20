class_name UI_root
extends CanvasLayer

@onready var ice_spear_upgrade_menu: UpgradeMenu = %UpgradeMenuIceSpear
@onready var explosion_upgrade_menu: UpgradeMenu = %UpgradeMenuExplosion
@onready var global_upgrade_menu: UpgradeMenu = %UpgradeMenuGlobal
@onready var elapsed_game_timer: ElapsedGameTimer = %ElapsedGameTimer
@onready var upgrade_icon := %NewUpgradeIcon

var ice_spear_drop_pickup: Upgrade = IceSpearDropPickupUpgrade.new()
var freeze_nova_on_pickup: Upgrade = FreezeNovaOnPickupUpgrade.new(ice_spear_drop_pickup)
var ice_spear_upgrades: Array[Upgrade] = [
	FlatDamageUpgrade.new(Enums.UpgradeType.ICE_SPEAR),
	# PercentDamageUpgrade.new(Enums.UpgradeType.ICE_SPEAR),
	IceSpearProjectilesUpgrade.new(),
	ProjSpdUpgrade.new(),
	PierceUpgrade.new(),
	ReturnUpgrade.new(),
	MaxStoredIceSpearsUpgrade.new(),
	ice_spear_drop_pickup,
	freeze_nova_on_pickup,
	FreezeNovaOnKillUpgrade.new(freeze_nova_on_pickup),
	KnockbackUpgrade.new(Enums.UpgradeType.ICE_SPEAR)
]

var burn_nova_on_kill: Upgrade = BurnNovaOnKillUpgrade.new()
var explosion_upgrades: Array[Upgrade] = [
	FlatDamageUpgrade.new(Enums.UpgradeType.EXPLOSION),
	# PercentDamageUpgrade.new(Enums.UpgradeType.EXPLOSION),
	ExplosionCountUpgrade.new(),
	AoeUpgrade.new(),
	BurnDamageUpgrade.new(),
	BurnDurationUpgrade.new(),
	burn_nova_on_kill,
	BurnNovaAoEUpgrade.new(burn_nova_on_kill),
	KnockbackUpgrade.new(Enums.UpgradeType.EXPLOSION)
]
var global_loot: Upgrade = GlobalLootUpgrade.new()
var global_upgrades: Array[Upgrade] = [
	# GlobalPickupRadius.new(),
	# GlobalAtkSpdUpgrade.new(),
	# GlobalMovSpdUpgrade.new(),
	global_loot,
	SpawnBossUpgrade.new(global_loot)
]

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		if ice_spear_upgrade_menu.visible:
			ice_spear_upgrade_menu.close()
			explosion_upgrade_menu.close()
			global_upgrade_menu.close()
			elapsed_game_timer.close()
			get_tree().paused = false
		else:
			ice_spear_upgrade_menu.open(ice_spear_upgrades)
			explosion_upgrade_menu.open(explosion_upgrades)
			global_upgrade_menu.open(global_upgrades)
			elapsed_game_timer.open()
			get_tree().paused = true

func _ready() -> void:
	Game.ice_spear_money_changed.connect(update_upgrade_icon)
	Game.explosion_money_changed.connect(update_upgrade_icon)

func buyable_upgrade_available() -> bool:
	for upgrade in ice_spear_upgrades:
		if upgrade.is_buyable() && !upgrade is KnockbackUpgrade:
			return true

	for upgrade in explosion_upgrades:
		if upgrade.is_buyable() && !upgrade is KnockbackUpgrade:
			return true

	for upgrade in global_upgrades:
		if upgrade.is_buyable() && !upgrade is GlobalLootUpgrade:
			return true

	return false

func update_upgrade_icon() -> void:
	# print("update")
	if buyable_upgrade_available():
		upgrade_icon.open()
		# print("open")
	else:
		upgrade_icon.close()
		# print("close")

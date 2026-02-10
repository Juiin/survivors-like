class_name FasterBurnRateUpgrade
extends Upgrade

@export var increase := 0.2


func _init():
	upgrade_name = "Faster [color=#ff7a3a][url]Burn[/url][/color] Rate"
	upgrade_description = "[color=#ff7a3a][url]Burns[/url][/color] deal damage 20% faster"
	cost = [25, 50, 75, 100, 125, 150, 200, 250, 300, 350, 400, 425, 450, 475, 500]
	type = Enums.UpgradeType.EXPLOSION
	#endless = true
	has_burn_hint = true

func apply_player_upgrade(player: Player) -> void:
	Game.faster_burn_rate += increase

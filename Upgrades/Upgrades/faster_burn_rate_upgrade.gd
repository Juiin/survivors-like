class_name FasterBurnRateUpgrade
extends Upgrade

@export var increase := 0.2


func _init():
	upgrade_name = "Faster Burn Rate"
	upgrade_description = "Burns deal damage 20% faster"
	cost = [25, 50, 75, 100, 125, 150, 200, 250, 300, 350, 400, 450, 500]
	type = Enums.UpgradeType.EXPLOSION
	#endless = true

func apply_player_upgrade(player: Player) -> void:
	Game.faster_burn_rate += increase

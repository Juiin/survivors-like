class_name BurnDamageUpgrade
extends Upgrade

var increase := 1.0


func _init():
	upgrade_name = "Burn Damage"
	upgrade_description = "+1 to Burn Damage per Second"
	cost = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50]
	type = Enums.UpgradeType.EXPLOSION

func apply_player_upgrade(player: Player) -> void:
	Game.burn_damage += increase

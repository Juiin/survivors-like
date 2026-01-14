class_name BurnDamageUpgrade
extends Upgrade

var increase := 1.0


func _init():
	upgrade_name = "Burn Damage"
	upgrade_description = "+1 to Burn Damage per Second"
	cost = [75, 125, 175, 225, 275, 325, 350, 375, 400, 425, 450, 475, 500]
	type = Enums.UpgradeType.EXPLOSION
	endless = true

func apply_player_upgrade(player: Player) -> void:
	Game.burn_damage += increase

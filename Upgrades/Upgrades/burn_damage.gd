class_name BurnDamageUpgrade
extends Upgrade

var increase := 1.0


func _init():
	upgrade_name = "Burn Damage"
	upgrade_description = "+1 to Burn Damage per Second"
	cost = [75, 150, 225, 300, 375, 450, 525, 600, 675, 750]
	type = Enums.UpgradeType.EXPLOSION
	endless = true

func apply_player_upgrade(player: Player) -> void:
	Game.burn_damage += increase

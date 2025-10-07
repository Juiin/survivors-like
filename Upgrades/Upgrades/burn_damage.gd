class_name BurnDamageUpgrade
extends Upgrade

var increase := 1.0


func _init():
	upgrade_name = "Burn Damage"
	upgrade_description = "+1 to Burn Damage per Second"
	cost = [150, 300, 450, 600, 750, 900, 1050, 1200, 1350, 1500]
	type = Enums.UpgradeType.EXPLOSION
	endless = true

func apply_player_upgrade(player: Player) -> void:
	Game.burn_damage += increase

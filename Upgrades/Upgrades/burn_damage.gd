class_name BurnDamageUpgrade
extends Upgrade

var increase := 1.0


func _init():
	upgrade_name = "[color=#ff7a3a][url]Burn[/url][/color] Damage"
	upgrade_description = "+1 to [color=#ff7a3a][url]Burn[/url][/color] Damage per Second"
	cost = [50, 100, 150, 200, 250, 300, 325, 350, 375, 400, 425, 450, 475, 500]
	type = Enums.UpgradeType.EXPLOSION
	endless = true
	has_burn_hint = true

func apply_player_upgrade(player: Player) -> void:
	Game.burn_damage += increase

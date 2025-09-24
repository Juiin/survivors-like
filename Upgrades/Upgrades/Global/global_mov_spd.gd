class_name GlobalMovSpdUpgrade
extends Upgrade

@export var increase := 10


func _init():
	upgrade_name = "Movement Speed"
	upgrade_description = "Increases Movement Speed by 10%"
	cost = [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000]
	type = Enums.UpgradeType.GLOBAL

func apply_player_upgrade(player: Player) -> void:
	player.spd += increase
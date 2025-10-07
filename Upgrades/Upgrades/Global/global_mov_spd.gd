class_name GlobalMovSpdUpgrade
extends Upgrade

@export var increase := 5


func _init():
	upgrade_name = "Movement Speed"
	upgrade_description = "Increases Movement Speed by 5%"
	cost = [50, 100, 150, 200, 250, 300, 350, 400, 450, 500]
	type = Enums.UpgradeType.GLOBAL
	endless = true
	charged_sprite = preload("uid://dbukqqfur7oyp")
	

func apply_player_upgrade(player: Player) -> void:
	player.spd += increase
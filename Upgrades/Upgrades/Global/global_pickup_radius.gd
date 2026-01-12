class_name GlobalPickupRadius
extends Upgrade

@export var increase_percent := 0.5


func _init():
	upgrade_name = "Pickup Radius"
	upgrade_description = "Increases Pickup Radius by 50%"
	cost = [50, 100, 150, 200, 250, 300, 350, 400, 450, 500]
	type = Enums.UpgradeType.GLOBAL
	endless = true
	charged_sprite = preload("uid://c4a6kk4yjdqgb")

func apply_player_upgrade(player: Player) -> void:
	player.pickup_radius_increase += increase_percent
	player.pickup_radius.scale = Vector2.ONE * (1 + player.pickup_radius_increase)

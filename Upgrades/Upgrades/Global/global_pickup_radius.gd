class_name GlobalPickupRadius
extends Upgrade

@export var increase_percent := 0.4


func _init():
	upgrade_name = "Pickup Radius"
	upgrade_description = "Increases Pickup Radius by %s"
	cost = [5, 10, 15]
	type = Enums.UpgradeType.GLOBAL
	upgrade_description = upgrade_description % increase_percent

func apply_player_upgrade(player: Player) -> void:
	player.pickup_radius_increase += increase_percent
	player.pickup_radius.scale = Vector2.ONE * (1 + player.pickup_radius_increase)

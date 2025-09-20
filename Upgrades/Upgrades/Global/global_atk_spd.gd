class_name GlobalAtkSpdUpgrade
extends Upgrade

@export var atk_spd_increase_percent := [0.2, 0.2, 0.2]


func _init():
	upgrade_name = "Attack Speed"
	upgrade_description = "Increases Attack Speed by 20%"
	cost = [5, 10, 15]
	type = Enums.UpgradeType.GLOBAL

func apply_player_upgrade(player: Player) -> void:
	player.atk_spd_increase += atk_spd_increase_percent[level]
	player.attack_timer.wait_time = player.base_atk_spd / (1 + player.atk_spd_increase)

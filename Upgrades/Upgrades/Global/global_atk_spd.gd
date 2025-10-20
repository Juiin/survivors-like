class_name GlobalAtkSpdUpgrade
extends Upgrade

@export var atk_spd_increase_percent := 0.05


func _init():
	upgrade_name = "Attack Speed"
	upgrade_description = "Increases Attack Speed by 5%"
	cost = [50, 100, 150, 250, 500, 600, 700, 800, 1000]
	type = Enums.UpgradeType.GLOBAL
	endless = true
	charged_sprite = preload("uid://bv56fmj0s8dn0")

func apply_player_upgrade(player: Player) -> void:
	player.atk_spd_increase += atk_spd_increase_percent
	player.attack_timer.wait_time = player.base_atk_spd / (1 + player.atk_spd_increase)
	player.attack_timer.wait_time = max(player.attack_timer.wait_time, 0.15)

class_name SpawnBossUpgrade
extends Upgrade


func _init(_req_upgrade: Upgrade):
	upgrade_name = "Spawn Boss"
	upgrade_description = "Do or die!"
	cost = [1000]
	type = Enums.UpgradeType.GLOBAL
	req_upgrade_level = 5
	req_upgrade = _req_upgrade

func apply_player_upgrade(player: Player) -> void:
	Game.boss_is_active = true
	var fire_ring = preload("res://boss/fire_ring_spawner.tscn").instantiate()
	player.get_tree().current_scene.add_child(fire_ring)
	fire_ring.global_position = player.global_position
extends Node

var player: Player
var spawn_path_follow: Node
signal ice_spear_money_changed
signal explosion_money_changed

const RAT_WEAK_STATS = preload("res://Enemies/rat_weak.tres")
const RAT_RED_STATS = preload("res://Enemies/rat_red.tres")
const CYCLOPS_STATS = preload("res://Enemies/cyclops.tres")
const AMEBA_STATS = preload("res://Enemies/ameba.tres")
const JUGGERNAUT_STATS = preload("res://Enemies/juggernaut.tres")

var elapsed_time: float = 0.0

var money_multi := 1.0
var enemy_health_multi := 1.0



var spawn_timer = Timer
var to_spawn_enemies: Array[Stats] = [RAT_WEAK_STATS]

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	spawn_path_follow = player.get_node("%SpawnPathFollow")
	spawn_timer = Timer.new()
	spawn_timer.connect("timeout", spawn_enemy)
	spawn_timer.set_wait_time(1)


	get_tree().current_scene.add_child(spawn_timer)
	spawn_timer.start()

func _process(delta: float) -> void:
	if not get_tree().paused:
		elapsed_time += delta

var ice_spear_money: int = 555:
	set(new_value):
		ice_spear_money = max(new_value, 0)
		ice_spear_money_changed.emit()
var explosion_money: int = 555:
	set(new_value):
		explosion_money = max(new_value, 0)
		explosion_money_changed.emit()

func enough_upgrade_cost(type: Enums.UpgradeType, amount: int):
	match type:
		Enums.UpgradeType.ICE_SPEAR:
			return ice_spear_money >= amount
		Enums.UpgradeType.EXPLOSION:
			return explosion_money >= amount
		Enums.UpgradeType.GLOBAL:
			return ice_spear_money >= amount && explosion_money >= amount

	return false

func adjust_money(type: Enums.UpgradeType, amount: int):
	amount *= money_multi
	match type:
		Enums.UpgradeType.ICE_SPEAR:
			ice_spear_money += amount
		Enums.UpgradeType.EXPLOSION:
			explosion_money += amount
		Enums.UpgradeType.GLOBAL:
			ice_spear_money += amount
			explosion_money += amount

func add_upgrade_to_player(type: Enums.UpgradeType, upgrade: Upgrade):
	match type:
		Enums.UpgradeType.ICE_SPEAR:
			player.ice_spear_upgrades.append(upgrade)
		Enums.UpgradeType.EXPLOSION:
			player.explosion_upgrades.append(upgrade)
		Enums.UpgradeType.GLOBAL:
			player.global_upgrades.append(upgrade)
			upgrade.apply_player_upgrade(player)

func spawn_enemy():
	var enemy_stats: Stats
	if to_spawn_enemies.size() > 0:
		enemy_stats = to_spawn_enemies.pop_front()
	
		if to_spawn_enemies.size() == 0:
			var enemy_count_from = remap(elapsed_time, 0, 600, 5, 20)
			var enemy_count_to = remap(elapsed_time, 0, 600, 10, 60)

			var enemy_count = randi_range(int(enemy_count_from), int(enemy_count_to))
			print("enemy_count: ", enemy_count)
			var possible_enemy_stats = [RAT_WEAK_STATS, RAT_RED_STATS, CYCLOPS_STATS, JUGGERNAUT_STATS, AMEBA_STATS]
			var max_possible_enemy_index = clamp(int(remap(elapsed_time, 0, 100, 0, possible_enemy_stats.size() - 1)), 0, possible_enemy_stats.size() - 1)
			print("max_possible_enemy_index: ", max_possible_enemy_index)
			var enemy_index = randi_range(0, max_possible_enemy_index)
			# enemy_count += remap(enemy_index, 0, possible_enemy_stats.size() - 1, enemy_count, 0)
			print("possible_enemy_stats[enemy_index]: ", possible_enemy_stats[enemy_index])
			
			for i in enemy_count:
				print("loop")
				to_spawn_enemies.append(possible_enemy_stats[enemy_index])

			print("to_spawn_enemies: ", to_spawn_enemies.size())
			
			var new_spawn_time = randf_range(0.5, 1.5)
			print("new_spawn_time: ", new_spawn_time)
			spawn_timer.set_wait_time(new_spawn_time)
			
				
	var enemy = preload("res://enemy.tscn").instantiate()
	spawn_path_follow.progress_ratio = randf()
	enemy.global_position = spawn_path_follow.global_position
	enemy.stats = enemy_stats
	get_tree().current_scene.get_node("%YSort").add_child(enemy)
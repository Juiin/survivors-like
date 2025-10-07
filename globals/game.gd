extends Node

var player: Player
var spawn_path_follow: Node
signal ice_spear_money_changed
signal explosion_money_changed

const SLIME_BLUE_STATS = preload("res://Enemies/slime_blue.tres")
const SLIME_RED_STATS = preload("res://Enemies/slime_red.tres")
const FROG_RED_STATS = preload("res://Enemies/frog_red.tres")
const FROG_BLUE_STATS = preload("res://Enemies/frog_blue.tres")
const EYE_BLUE_STATS = preload("res://Enemies/eye_blue.tres")
const EYE_RED_STATS = preload("res://Enemies/eye_red.tres")
const RAT_WEAK_STATS = preload("res://Enemies/rat_weak.tres")
const RAT_RED_STATS = preload("res://Enemies/rat_red.tres")
const TREE_STUMP_RED_STATS = preload("res://Enemies/tree_stump_red.tres")
const TREE_STUMP_BLUE_STATS = preload("res://Enemies/tree_stump_blue.tres")
const SNAIL_RED_STATS = preload("res://Enemies/snail_red.tres")
const SNAIL_BLUE_STATS = preload("res://Enemies/snail_blue.tres")
const SHROOM_RED_STATS = preload("res://Enemies/shroom_red.tres")
const SHROOM_BLUE_STATS = preload("res://Enemies/shroom_blue.tres")
const WORM_RED_STATS = preload("res://Enemies/worm_red.tres")
const WORM_BLUE_STATS = preload("res://Enemies/worm_blue.tres")
const PLANT_RED_STATS = preload("res://Enemies/plant_red.tres")
const PLANT_BLUE_STATS = preload("res://Enemies/plant_blue.tres")
const HORNET_BLUE_STATS = preload("res://Enemies/hornet_blue.tres")
const HORNET_RED_STATS = preload("res://Enemies/hornet_red.tres")
const JUGGERNAUT_STATS = preload("res://Enemies/juggernaut.tres")
const CYCLOPS_STATS = preload("res://Enemies/cyclops.tres")
const TORNADO_RED_STATS = preload("res://Enemies/tornado_red.tres")
const TORNADO_BLUE_STATS = preload("res://Enemies/tornado_blue.tres")
const CRAB_RED_STATS = preload("res://Enemies/crab_red.tres")
const CRAB_BLUE_STATS = preload("res://Enemies/crab_blue.tres")
const TENTACLE_BALL_RED_STATS = preload("res://Enemies/tentacle_ball_red.tres")
const TENTACLE_BALL_BLUE_STATS = preload("res://Enemies/tentacle_ball_blue.tres")
const GHOST_BLUE_STATS = preload("res://Enemies/ghost_blue.tres")
const GHOST_RED_STATS = preload("res://Enemies/ghost_red.tres")
const FIRE_RED_STATS = preload("res://Enemies/fire_red.tres")
const FIRE_BLUE_STATS = preload("res://Enemies/fire_blue.tres")
const CYCLOPS_SMALL_RED_STATS = preload("res://Enemies/cyclops_small_red.tres")
const CYCLOPS_SMALL_BLUE_STATS = preload("res://Enemies/cyclops_small_blue.tres")
const CRYSTAL_RED_STATS = preload("res://Enemies/crystal_red.tres")
const CRYSTAL_BLUE_STATS = preload("res://Enemies/crystal_blue.tres")
const ZOMBIE_BLUE_STATS = preload("res://Enemies/zombie_blue.tres")
const ZOMBIE_RED_STATS = preload("res://Enemies/zombie_red.tres")
const WRAITH_RED_STATS = preload("res://Enemies/wraith_red.tres")
const WRAITH_BLUE_STATS = preload("res://Enemies/wraith_blue.tres")
const STONE_RED_STATS = preload("res://Enemies/stone_red.tres")
const STONE_BLUE_STATS = preload("res://Enemies/stone_blue.tres")
const AMEBA_STATS = preload("res://Enemies/ameba.tres")
const AMEBA_RED_STATS = preload("res://Enemies/ameba_red.tres")
const ARMOUR_RED_STATS = preload("res://Enemies/armour_red.tres")
const ARMOUR_BLUE_STATS = preload("res://Enemies/armour_blue.tres")
const WIZARD_BLUE_STATS = preload("res://Enemies/wizard_blue.tres")
const WIZARD_RED_STATS = preload("res://Enemies/wizard_red.tres")

const CHEST_BLUE_STATS = preload("res://Enemies/chest_blue.tres")
const CHEST_RED_STATS = preload("res://Enemies/chest_red.tres")

const POSSIBLE_ENEMY_STATS = [
	SLIME_BLUE_STATS,
	SLIME_RED_STATS,
	FROG_RED_STATS,
	FROG_BLUE_STATS,
	EYE_BLUE_STATS,
	EYE_RED_STATS,
	RAT_WEAK_STATS,
	RAT_RED_STATS,
	TREE_STUMP_RED_STATS,
	TREE_STUMP_BLUE_STATS,
	SNAIL_RED_STATS,
	SNAIL_BLUE_STATS,
	SHROOM_RED_STATS,
	SHROOM_BLUE_STATS,
	WORM_RED_STATS,
	WORM_BLUE_STATS,
	PLANT_RED_STATS,
	PLANT_BLUE_STATS,
	HORNET_BLUE_STATS,
	HORNET_RED_STATS,
	JUGGERNAUT_STATS,
	CYCLOPS_STATS,
	TORNADO_RED_STATS,
	TORNADO_BLUE_STATS,
	CRAB_RED_STATS,
	CRAB_BLUE_STATS,
	TENTACLE_BALL_RED_STATS,
	TENTACLE_BALL_BLUE_STATS,
	GHOST_BLUE_STATS,
	GHOST_RED_STATS,
	FIRE_RED_STATS,
	FIRE_BLUE_STATS,
	CYCLOPS_SMALL_RED_STATS,
	CYCLOPS_SMALL_BLUE_STATS,
	CRYSTAL_RED_STATS,
	CRYSTAL_BLUE_STATS,
	ZOMBIE_BLUE_STATS,
	ZOMBIE_RED_STATS,
	WRAITH_RED_STATS,
	WRAITH_BLUE_STATS,
	STONE_RED_STATS,
	STONE_BLUE_STATS,
	AMEBA_STATS,
	AMEBA_RED_STATS,
	ARMOUR_RED_STATS,
	ARMOUR_BLUE_STATS,
	WIZARD_BLUE_STATS,
	WIZARD_RED_STATS
]


const ENEMY_TYPES = [RAT_WEAK_STATS, RAT_RED_STATS, CYCLOPS_STATS, JUGGERNAUT_STATS, AMEBA_STATS]

var elapsed_time: float = 0.0

var money_multi := 1.0
var enemy_health_multi := 1.0

var burn_damage := 1.0
var burn_duration := 3.0
var burn_nova_on_kill = 0.0
var burn_nova_scale_multi := 1.0

var freeze_nova_on_kill = 0.0

var spawn_timer = Timer
var health_enemy_spawn_timer = Timer
var to_spawn_enemies: Array[Stats] = [SLIME_RED_STATS]

var total_currency_collected := 0

var active_enemies := 0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	spawn_path_follow = player.get_node("%SpawnPathFollow")
	spawn_timer = Timer.new()
	spawn_timer.connect("timeout", spawn_enemy)
	spawn_timer.set_wait_time(1)

	health_enemy_spawn_timer = Timer.new()
	health_enemy_spawn_timer.connect("timeout", spawn_health_enemy)
	health_enemy_spawn_timer.set_wait_time(90)

	get_tree().current_scene.add_child(spawn_timer)
	get_tree().current_scene.add_child(health_enemy_spawn_timer)
	spawn_timer.start()
	health_enemy_spawn_timer.start()

func _process(delta: float) -> void:
	if not get_tree().paused:
		elapsed_time += delta

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_give_money"):
		ice_spear_money += 100
		explosion_money += 100
	if event.is_action_pressed("debug_give_money_alot"):
		ice_spear_money += 10000
		explosion_money += 10000

var ice_spear_money: int = 0:
	set(new_value):
		total_currency_collected += new_value - ice_spear_money
		ice_spear_money = max(new_value, 0)
		ice_spear_money_changed.emit()
var explosion_money: int = 0:
	set(new_value):
		total_currency_collected += new_value - explosion_money
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
	const MAX_CURRENCY = 30000
	if to_spawn_enemies.size() > 0:
		enemy_stats = to_spawn_enemies.pop_front()
	
	if enemy_stats:
		var enemy_hp = remap(total_currency_collected, 0, MAX_CURRENCY, 50, 3000)
		enemy_hp *= randf_range(0.7, 1.3)
		var at_once_enemies = ceili(enemy_hp / enemy_stats.max_health)
		at_once_enemies = clamp(at_once_enemies, 1, 100)
		print("at_once_enemies: ", at_once_enemies)

		# var swarm_chance = remap(total_currency_collected, 0, MAX_CURRENCY, 0.001, 0.005)
		var swarm_chance = 0
		if randf() <= swarm_chance:
			at_once_enemies *= 3
			print("Swarm!")
		for i in at_once_enemies:
			var enemy = preload("res://enemy.tscn").instantiate()
			var new_scale = randf_range(1.3, 2.0)
			spawn_path_follow.get_parent().scale = Vector2(new_scale, new_scale)
			spawn_path_follow.progress_ratio = randf()
			enemy.global_position = spawn_path_follow.global_position
			enemy.stats = enemy_stats
			get_tree().current_scene.get_node("%YSort").add_child(enemy)
			if (randf() <= 0.05):
				enemy.make_elite()

	# if spawn list is empty try to add a new one
	if to_spawn_enemies.size() == 0:
		const MAX_ENEMY_SPAWN_REQ_MONEY = 8000
		var max_index = int(remap(total_currency_collected, 0, MAX_ENEMY_SPAWN_REQ_MONEY, 2, (POSSIBLE_ENEMY_STATS.size() - 1) / 2))
		max_index *= 2
		max_index = clamp(max_index, 0, POSSIBLE_ENEMY_STATS.size() - 1)

		var possible_enemy_stats = POSSIBLE_ENEMY_STATS.slice(max(0, max_index + 2 - 20), max_index + 2)

		# dont allow same stats twice in a row
		possible_enemy_stats = possible_enemy_stats.filter(
			func(s): return s != enemy_stats
		)

		var enemy_index = randi_range(0, possible_enemy_stats.size() - 1)
		
		
		# var from_spawn_time = remap(total_currency_collected, 0, MAX_CURRENCY, 7, 1)
		# var to_spawn_time = remap(total_currency_collected, 0, MAX_CURRENCY, 11, 3)
		# var new_spawn_time = randf_range(from_spawn_time, to_spawn_time)

		var min_enemy_count = remap(total_currency_collected, 0, MAX_CURRENCY, 20, 100)
		min_enemy_count = clamp(min_enemy_count, 20, 100)
		var max_enemy_count = remap(total_currency_collected, 0, MAX_CURRENCY, 150, 300)
		max_enemy_count = clamp(max_enemy_count, 150, 300)

		const BASE_SPAWN_TIME = 6
		var new_spawn_time = BASE_SPAWN_TIME
		if active_enemies < min_enemy_count:
			new_spawn_time = remap(active_enemies, 0, min_enemy_count, 0, BASE_SPAWN_TIME)

		new_spawn_time = max(new_spawn_time, 1)
		spawn_timer.set_wait_time(new_spawn_time)

		if active_enemies < max_enemy_count:
			print(active_enemies)
			to_spawn_enemies.append(possible_enemy_stats[enemy_index])

func spawn_health_enemy():
	var enemy = preload("res://enemy.tscn").instantiate()
	spawn_path_follow.progress_ratio = randf()
	enemy.global_position = spawn_path_follow.global_position
	enemy.stats = [CHEST_BLUE_STATS, CHEST_RED_STATS].pick_random()
	enemy.scale *= 2
	get_tree().current_scene.get_node("%YSort").add_child(enemy)
	print(active_enemies)

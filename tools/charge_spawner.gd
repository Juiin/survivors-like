@tool
extends Node

@export var spawn_chargers: bool = false: set = _set_spawn_chargers
@export var noise: FastNoiseLite
@export var spawner: PackedScene

var spawned_instances := []

const WIDTH = 640 * 20
const HEIGHT = 360 * 20

func _set_spawn_chargers(_value: bool) -> void:
	spawn_chargers = false
	for inst in get_children():
		inst.queue_free()
	spawned_instances.clear()

	noise.seed = randi()

	const START_X = - WIDTH / 2
	const START_Y = - HEIGHT / 2

	for i in WIDTH:
		for j in HEIGHT:
			var value = noise.get_noise_2d(START_X + i, START_Y + j)
			if value > 0.5:
				var pos = Vector2(START_X + i, START_Y + j)
				var min_distance = 128 # Adjust as needed
				var too_close = false
				for other in spawned_instances:
					if other.global_position.distance_to(pos) < min_distance:
						too_close = true
						break
				if too_close:
					continue
				var inst = spawner.instantiate()
				var possible_upgrades = [GlobalAtkSpdUpgrade.new(), GlobalMovSpdUpgrade.new(), GlobalPickupRadius.new(), GlobalPercentDamageUpgrade.new()]
				inst.upgrade = possible_upgrades[randi() % possible_upgrades.size()]
				add_child(inst)
				inst.global_position = Vector2(START_X + i, START_Y + j)
				inst.set_owner(get_tree().get_edited_scene_root())
				spawned_instances.append(inst)

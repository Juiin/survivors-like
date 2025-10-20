extends Node2D

var rock_scene = preload("res://boss/rock.tscn")
var player: Player

var at_player_timer: Timer
var random_timer: Timer
var random_offset := 200.0
@onready var throw_marker := $"../ThrowMarker"

var at_player_interval := 2.0
var at_random_interval := 1.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	at_player_timer = Timer.new()
	at_player_timer.connect("timeout", func(): throw_rock(player.global_position))

	at_player_timer.set_wait_time(at_player_interval)
	add_child(at_player_timer)
	at_player_timer.start()

	random_timer = Timer.new()
	random_timer.connect("timeout", func():
		for i in range(3):
			await get_tree().create_timer(0.2).timeout
			throw_rock(player.global_position + Vector2(randf_range(-random_offset, random_offset), randf_range(-random_offset, random_offset))))

	random_timer.set_wait_time(at_random_interval)
	add_child(random_timer)
	random_timer.start()

func throw_rock(_target: Vector2):
	var rock = rock_scene.instantiate()
	rock.target = _target

	rock.global_position = throw_marker.global_position
	get_tree().current_scene.add_child(rock)
	print(throw_marker.global_position)

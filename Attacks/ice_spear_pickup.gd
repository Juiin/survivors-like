class_name IceSpearPickup
extends Area2D

static var instances := []
var spd := -2.0
var target: CharacterBody2D
const MAX_PICKUPS = 150
var pickup_snd = preload("res://Audio/ice_spear_pickup.ogg")
var freeze_nova_scene := load("res://Attacks/freeze_nova.tscn")
func _ready() -> void:
	instances.append(self)
	connect("tree_exited", _on_tree_exited)
	if instances.size() > MAX_PICKUPS:
		var oldest = instances[0]
		instances.remove_at(0)
		oldest.queue_free()

func _physics_process(delta: float) -> void:
	if target:
		global_position = global_position.move_toward(target.global_position, spd)
		spd += 5.2 * delta

func _on_tree_exited() -> void:
	instances.erase(self)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Utils.play_audio(pickup_snd, 0.9, 1.1, 0.35)
		body.ice_spear_stored += 1
		if body.freeze_nova_on_pickup:
			var nova = freeze_nova_scene.instantiate()
			nova.position = global_position
			get_tree().current_scene.call_deferred("add_child", nova)
		queue_free()

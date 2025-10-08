class_name IceSpearPickup
extends Area2D

static var instances := []

const MAX_PICKUPS = 150

func _ready() -> void:
	instances.append(self)
	connect("tree_exited", _on_tree_exited)
	if instances.size() > MAX_PICKUPS:
		var oldest = instances[0]
		instances.remove_at(0)
		oldest.queue_free()

func _on_tree_exited() -> void:
	instances.erase(self)

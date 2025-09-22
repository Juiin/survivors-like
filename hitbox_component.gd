class_name HitboxComponent
extends Node

@export var damage := 10.0
@export var hit_list_clear_time: float = 0
@export var area_2d: Area2D
@export var hit_limit: int = 1

var hit_count := 0

var player_in_area_timer: float = 0.0

var hit_list: Array[Dictionary] = []


func _ready() -> void:
	# area_2d.connect("area_entered", _on_area_entered)
	pass

	
func _process(delta: float) -> void:
	if "frozen" in owner and owner.frozen:
		return

	update_hit_list()

	var overlapping_areas := area_2d.get_overlapping_areas()
	for area in overlapping_areas:
		var is_in_hit_list = false
		for i in hit_list:
			if i.area == area:
				is_in_hit_list = true

		if is_in_hit_list:
			continue
		
		
		var hurtbox_child = Utils.get_child_by_class(area, HurtboxComponent)
		if hurtbox_child:
			var dmg_color = Color.WHITE
			if hurtbox_child.owner is Player:
				player_in_area_timer += delta
				if player_in_area_timer <= 1.0:
					continue
				player_in_area_timer = 0
				get_tree().get_first_node_in_group("camera").screen_shake(10, 0.5)
				Utils.play_audio(preload("res://Audio/hurt.mp3"), 0.95, 1.05)
				dmg_color = Color.RED
			hurtbox_child.take_damage(damage)
			Effects.spawn_damage_text(damage, area.global_position, dmg_color)
			hit_list.append({"area": area, "time": Time.get_ticks_msec() / 1000.0})
			hit_count += 1
			if hit_count >= hit_limit:
				owner.die()

# func _on_area_entered(area: Area2D) -> void:
# 	var hurtbox_child = Utils.get_child_by_class(area, HurtboxComponent)
# 	if hurtbox_child:
# 		hurtbox_child.take_damage(damage)

func update_hit_list() -> void:
	if hit_list_clear_time <= 0:
		return

	var now := Time.get_ticks_msec() / 1000.0
	for i in range(hit_list.size() - 1, -1, -1):
		if now - hit_list[i].time >= hit_list_clear_time:
			hit_list.remove_at(i)
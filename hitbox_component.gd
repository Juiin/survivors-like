class_name HitboxComponent
extends Node

@export var base_damage := 10.0
@export var hit_list_clear_time: float = 0
@export var area_2d: Area2D
@export var hit_limit: int = -1
@export var knockback_amount := 0.0

var flat_dmg := 0.0:
	set(value):
		flat_dmg = value
		recalc_dmg()
var percent_dmg := 0.0:
	set(value):
		percent_dmg = value
		recalc_dmg()

var damage_against_burning := 0.0
var damage_against_frozen := 0.0

var damage: float

var hit_count := 0

var player_in_area_timer: float = 0.0

var hit_list: Array[Dictionary] = []

func _ready() -> void:
	recalc_dmg()

func recalc_dmg() -> void:
	damage = (base_damage + flat_dmg) * (1 + percent_dmg)

	
func _process(delta: float) -> void:
	if Game.player_is_dead:
		return

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
				#Utils.play_audio(preload("res://Audio/hurt.mp3"), 0.95, 1.05)
				dmg_color = Color.RED
				var blood = preload("res://Effects/blood.tscn").instantiate()
				blood.global_position = area.global_position
				blood.rotation = area_2d.global_position.angle_to_point(area.global_position)
				get_tree().current_scene.add_child(blood)
			var final_damage = damage
			if "burning" in hurtbox_child.owner and hurtbox_child.owner.burning:
				final_damage *= 1 + damage_against_burning
			if "frozen" in hurtbox_child.owner and hurtbox_child.owner.frozen:
				final_damage *= 1 + damage_against_frozen

			hurtbox_child.take_damage(final_damage)
			if hurtbox_child.owner.has_method("get_knockbacked"):
				hurtbox_child.owner.get_knockbacked(area_2d.global_position.direction_to(area.global_position), knockback_amount)
			Effects.spawn_damage_text(final_damage, area.global_position, dmg_color)
			hit_list.append({"area": area, "time": Time.get_ticks_msec() / 1000.0})
			hit_count += 1
			if hit_limit != -1 && hit_count >= hit_limit:
				owner.die()


func update_hit_list() -> void:
	if hit_list_clear_time <= 0:
		return

	var now := Time.get_ticks_msec() / 1000.0
	for i in range(hit_list.size() - 1, -1, -1):
		if now - hit_list[i].time >= hit_list_clear_time:
			hit_list.remove_at(i)
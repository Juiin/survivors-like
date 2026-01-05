class_name Player
extends CharacterBody2D

var base_spd := 70.0
var spd := base_spd
var mov_spd_increase := 0.0

@onready var anim := $AnimatedSprite2D
@onready var attack_timer := $AttackTimer
var base_atk_spd := 1.5
var atk_spd_increase := 0.0
var global_percent_dmg_increase := 0.0
@onready var health_component := $HealthComponent
@onready var pickup_radius: Area2D = $PickupRadius
var pickup_radius_increase := 0.0
@export var stats: Stats

var ice_spear_scene := load("res://ice_spear.tscn")
var explosion_scene := load("res://explosion.tscn")
var freeze_nova_scene := load("res://Attacks/freeze_nova.tscn")

var freeze_nova_on_pickup := false

var ice_spear_upgrades: Array[Upgrade] = []
var explosion_upgrades: Array[Upgrade] = []
var global_upgrades: Array[Upgrade] = []

var ice_spear_projectiles := 1
var explosion_count := 1

enum form {
	ST,
	AOE,
	DEF
}

var current_form: form = form.ST

var ice_spear_stored := 0: set = update_ice_spear_stored
var max_ice_spear_stored := 3
var ice_spear_store_time := 3.0

func _ready() -> void:
	attack_timer.wait_time = base_atk_spd / (1 + atk_spd_increase)
	attack_timer.start()
	attack_timer.timeout.connect(attack)

	create_tween().set_loops().tween_callback(
		func():
			update_ice_spear_stored(ice_spear_stored + 1)
	).set_delay(ice_spear_store_time)
	
	health_component.connect("died", died)
	health_component.connect("took_damage", flash)

func _physics_process(delta):
	## Moving
	var move_dir = Input.get_vector("left", "right", "up", "down")
	velocity = move_dir * spd
	move_and_slide()

	global_position = global_position.clamp(Vector2(-640 * 10, -360 * 10), Vector2(640 * 10, 360 * 10))

	if velocity.length() > 0:
		anim.play("default")
	else:
		anim.stop()

	## Form Changing
	if Input.is_action_just_pressed("1"):
		current_form = form.ST
		play_swap_sfx()
	if Input.is_action_just_pressed("2"):
		current_form = form.AOE
		play_swap_sfx()
	if Input.is_action_just_pressed("swap_weapon"):
		current_form = form.ST if current_form == form.AOE else form.AOE
		play_swap_sfx()

	
func play_swap_sfx():
	var ice_spear_selected = preload("res://Effects/ice_spear_selected.tscn")
	var explosion_selected = preload("res://Effects/explosion_selected.tscn")
	if current_form == form.ST:
		var ice_spear_inst = ice_spear_selected.instantiate()
		ice_spear_inst.position = Vector2(0, -70)
		add_child(ice_spear_inst)
		var destroy_tween = create_tween()
		destroy_tween.tween_property(ice_spear_inst.material, "shader_parameter/alpha_multiplier", 0, 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		destroy_tween.tween_callback(func(): ice_spear_inst.queue_free())
		Utils.play_audio(preload("res://Audio/swap_to_ice.mp3"), 0.8, 0.86, 0.3)
	elif current_form == form.AOE:
		var explosion_inst = explosion_selected.instantiate()
		explosion_inst.position = Vector2(0, -70)
		add_child(explosion_inst)
		var destroy_tween = create_tween()
		destroy_tween.tween_property(explosion_inst.material, "shader_parameter/alpha_multiplier", 0, 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		destroy_tween.parallel().tween_property(explosion_inst.get_node("Sprite2D"), "modulate:a", 0, 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		destroy_tween.tween_callback(func(): explosion_inst.queue_free())
		Utils.play_audio(preload("res://Audio/swap_to_explosion_2.mp3"), 0.9, 1.1, 0.5)

func attack():
	var atk_count = 1;
	if current_form == form.ST:
		if ice_spear_stored > 0:
			atk_count = ice_spear_stored + 1
			if ice_spear_stored >= 3:
				var nova = preload("res://Attacks/freeze_nova.tscn").instantiate()
				nova.position = global_position
				nova.scale += Vector2(2.5, 2.5)
				get_tree().current_scene.add_child(nova)
			ice_spear_stored = 0
	elif current_form == form.AOE:
		atk_count = explosion_count

	var starting_pos = get_global_mouse_position() if current_form == form.AOE else global_position
	var attack_count = 1
	if current_form == form.ST:
		attack_count = ice_spear_projectiles
	for i in atk_count:
		create_tween().tween_callback(
			func():
				for j in attack_count:
					var inst=get_attack_scene().instantiate()
					inst.batch_number=i if current_form == form.AOE else j
					inst.global_position=starting_pos
					get_tree().current_scene.add_child(inst)
					var upgrade_array: Array[Upgrade]=ice_spear_upgrades if current_form == form.ST else explosion_upgrades
					for upgrade in upgrade_array.size():
						upgrade_array[upgrade].apply_upgrade(inst)
					inst.hitbox_component.percent_dmg += global_percent_dmg_increase
					if current_form == form.AOE:
						inst.adjust_position()
					).set_delay(i * (0.2 - i * 0.01))

	
func update_ice_spear_stored(amount: int) -> void:
	ice_spear_stored = min(amount, max_ice_spear_stored)
	%StoredIceSpears.update_count(ice_spear_stored)

func died() -> void:
	print("player died")

func get_attack_scene() -> PackedScene:
	match current_form:
		form.ST:
			return ice_spear_scene
		form.AOE:
			return explosion_scene
	
	return null

func flash() -> void:
	anim.material.set_shader_parameter("hit_flash_on", true)
	create_tween().tween_callback(func(): anim.material.set_shader_parameter("hit_flash_on", false)).set_delay(0.2)

func _on_pickup_radius_area_entered(area: Area2D) -> void:
	if area.is_in_group("money") || area.is_in_group("ice_spear_pickup"):
		area.target = self
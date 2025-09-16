class_name Player
extends CharacterBody2D

var spd := 150.0

@onready var anim := $AnimatedSprite2D
@onready var attack_timer := $AttackTimer
@onready var health_component := $HealthComponent

@export var stats: Stats

var ice_spear_scene := preload("res://ice_spear.tscn")
var explosion_scene := preload("res://explosion.tscn")

var ice_spear_upgrades: Array[Upgrade] = []
var explosion_upgrades: Array[Upgrade] = []

enum form {
	ST,
	AOE,
	DEF
}

var current_form: form = form.ST

var ice_spear_stored := 0
var max_ice_spear_stored := 5
var ice_spear_store_time := 2.0

func _ready() -> void:
	attack_timer.wait_time = 0.5
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

	if velocity.length() > 0:
		anim.play("default")
	else:
		anim.stop()

	## Form Changing
	if Input.is_action_just_pressed("1"):
		current_form = form.ST
	if Input.is_action_just_pressed("2"):
		current_form = form.AOE
	if Input.is_action_just_pressed("3"):
		Effects.spawn_damage_text(5, get_global_mouse_position())

func attack():
	var atk_count = 1;
	if current_form == form.ST && ice_spear_stored > 0:
		atk_count = ice_spear_stored + 1
		update_ice_spear_stored(0)

	for i in atk_count:
		create_tween().tween_callback(
			func():
				var inst=get_attack_scene().instantiate()
				
				get_tree().current_scene.add_child(inst)
				
				var upgrade_array: Array[Upgrade]=ice_spear_upgrades if current_form == form.ST else explosion_upgrades
				for upgrade in upgrade_array.size():
					upgrade_array[upgrade].apply_upgrade(inst)
				).set_delay(i * 0.2)
		

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

func _on_pickup_radius_area_entered(area:Area2D) -> void:
	if area.is_in_group("money"):
		area.target = self
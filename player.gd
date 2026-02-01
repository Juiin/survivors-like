class_name Player
extends CharacterBody2D

var base_spd := 75.0
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
@onready var sprite := $AnimatedSprite2D
@onready var light := $Light
@onready var freeze_nova_indicator_particles := $FreezeNovaIndicator

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
var base_ice_spear_store_time := 4.0
var increased_ice_spear_store_time := 0.0
var ice_spear_store_time := base_ice_spear_store_time:
	set(value):
		ice_spear_store_time = value
		_restart_ice_spear_tween()
var ice_spear_store_tween: Tween

func _restart_ice_spear_tween():
	if ice_spear_store_tween and ice_spear_store_tween.is_running():
		ice_spear_store_tween.kill()

	ice_spear_store_tween = create_tween()
	ice_spear_store_tween.set_loops()

	ice_spear_store_tween.tween_callback(func():
		update_ice_spear_stored(ice_spear_stored + 1)
	).set_delay(ice_spear_store_time)


func _ready() -> void:
	attack_timer.wait_time = base_atk_spd / (1 + atk_spd_increase)
	attack_timer.start()
	attack_timer.timeout.connect(attack)

	ice_spear_store_tween = create_tween()
	ice_spear_store_tween.set_loops().tween_callback(
		func():
			update_ice_spear_stored(ice_spear_stored + 1)
	).set_delay(ice_spear_store_time)
	
	health_component.connect("died", died)
	health_component.connect("took_damage", flash)

	_spawn_loop()

func _create_trail():
	var trail = load("res://Effects/ghost_trail.tscn").instantiate()
	get_tree().current_scene.add_child(trail)
	trail.global_position = global_position
	var trail_color: Vector3
	match current_form:
		form.ST:
			trail_color = Vector3(0.1, 0.2, 1.0)
		form.AOE:
			trail_color = Vector3(0.65, 0.0, 0)
	trail.material.set_shader_parameter("color_array", [trail_color])

func _spawn_loop():
	while true:
		await get_tree().create_timer(0.1).timeout
		_create_trail()

func _physics_process(delta):
	if Game.player_is_dead:
		return

	## Moving
	var move_dir = Input.get_vector("left", "right", "up", "down")
	velocity = move_dir * spd
	move_and_slide()

	global_position = global_position.clamp(Vector2(-640 * 10, -360 * 10), Vector2(640 * 10, 360 * 10))

	if velocity.length() > 0:
		anim.play()
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
	var ice_spear_selected = load("res://Effects/ice_spear_selected.tscn")
	var explosion_selected = load("res://Effects/explosion_selected.tscn")
	if current_form == form.ST:
		var ice_spear_inst = ice_spear_selected.instantiate()
		ice_spear_inst.position = Vector2(0, -70)
		add_child(ice_spear_inst)
		var destroy_tween = create_tween()
		destroy_tween.tween_property(ice_spear_inst.material, "shader_parameter/alpha_multiplier", 0, 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		destroy_tween.parallel().tween_property(ice_spear_inst.get_node("IceSpear"), "modulate:a", 0, 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		destroy_tween.parallel().tween_property(ice_spear_inst.get_node("Koori"), "modulate:a", 0, 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		destroy_tween.parallel().tween_property(ice_spear_inst.get_node("Koori").material, "shader_parameter/alpha_multiplier", 0, 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		destroy_tween.tween_callback(func(): ice_spear_inst.queue_free())
		Utils.play_audio(load("res://Audio/swap_to_ice.mp3"), 0.8, 0.86, 0.3)
		sprite.animation = "ice"
		light.material.set_shader_parameter("light_color", Vector3(0, 100, 255))
	elif current_form == form.AOE:
		var explosion_inst = explosion_selected.instantiate()
		explosion_inst.position = Vector2(0, -70)
		add_child(explosion_inst)
		var destroy_tween = create_tween()
		destroy_tween.tween_property(explosion_inst.material, "shader_parameter/alpha_multiplier", 0, 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		destroy_tween.parallel().tween_property(explosion_inst.get_node("Sprite2D"), "modulate:a", 0, 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		destroy_tween.parallel().tween_property(explosion_inst.get_node("Hi"), "modulate:a", 0, 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		destroy_tween.parallel().tween_property(explosion_inst.get_node("Hi").material, "shader_parameter/alpha_multiplier", 0, 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		destroy_tween.tween_callback(func(): explosion_inst.queue_free())
		Utils.play_audio(load("res://Audio/swap_to_explosion_2.mp3"), 0.9, 1.1, 0.5)
		sprite.animation = "default"
		light.material.set_shader_parameter("light_color", Vector3(255, 100, 0))

func attack():
	if Game.player_is_dead:
		return

	var form_snapshot = current_form

	var atk_count = 1;
	if form_snapshot == form.ST:
		if ice_spear_stored > 0:
			atk_count = ice_spear_stored + 1
			if ice_spear_stored >= 3:
				var nova = load("res://Attacks/freeze_nova.tscn").instantiate()
				nova.position = global_position
				nova.scale *= Game.freeze_nova_scale_multi
				var nova_scale_bonus = remap(ice_spear_stored, 3, 6, 1.5, 3.0)
				nova.scale += Vector2(nova_scale_bonus, nova_scale_bonus)
				get_tree().current_scene.add_child(nova)
			ice_spear_stored = 0
	elif form_snapshot == form.AOE:
		atk_count = explosion_count

	var starting_pos = get_global_mouse_position() if form_snapshot == form.AOE else global_position
	var attack_count = 1
	if form_snapshot == form.ST:
		attack_count = ice_spear_projectiles
	for i in atk_count:
		var i_snapshot = i
		create_tween().tween_callback(
			func():
				for j in attack_count:
					var inst=get_attack_scene(form_snapshot).instantiate()
					inst.batch_number=i_snapshot if form_snapshot == form.AOE else j
					inst.global_position=starting_pos if form_snapshot == form.AOE else global_position
					get_tree().current_scene.add_child(inst)
					var upgrade_array: Array[Upgrade]=ice_spear_upgrades if form_snapshot == form.ST else explosion_upgrades
					for upgrade in upgrade_array.size():
						upgrade_array[upgrade].apply_upgrade(inst)
					inst.hitbox_component.percent_dmg += global_percent_dmg_increase
					if form_snapshot == form.AOE:
						inst.adjust_position()
					).set_delay(i * (0.2 - i * 0.01))

	
func update_ice_spear_stored(amount: int) -> void:
	ice_spear_stored = min(amount, max_ice_spear_stored)
	var part_01 = preload("res://Textures/Particles/circle_022.png")
	var part_02 = preload("res://Textures/Particles/circle_02.png")
	var part_03 = preload("res://Textures/Particles/circle_0222.png")
	
	match ice_spear_stored:
		0:
			freeze_nova_indicator_particles.visible = false
		1:
			freeze_nova_indicator_particles.texture = part_01
			freeze_nova_indicator_particles.visible = true
		2:
			freeze_nova_indicator_particles.texture = part_02
			freeze_nova_indicator_particles.visible = true
		_:
			freeze_nova_indicator_particles.texture = part_03
			freeze_nova_indicator_particles.visible = true


	%StoredIceSpears.update_count(ice_spear_stored)

func died() -> void:
	#get_tree().paused = true
	#process_mode = Node.PROCESS_MODE_ALWAYS
	Utils.play_audio(load("res://Audio/SoundEffect/PlayerDeath.mp3"))
	Game.player_is_dead = true
	get_node("Camera2D").drag_horizontal_enabled = false
	get_node("Camera2D").drag_vertical_enabled = false
	for i in 30:
		create_tween().tween_callback(
			func():
				var blood=preload("res://Effects/blood.tscn").instantiate()
				blood.global_position=global_position
				blood.rotation=randf_range(0, PI * 2)
				get_tree().current_scene.add_child(blood)
		).set_delay(i * 0.1)
	

	var die_tween = create_tween()
	die_tween.tween_callback(die_transition).set_delay(3)

func die_transition() -> void:
	Transition.focus_center = true
	Transition.change_scene_to("res://main_menu.tscn")

func get_attack_scene(form_snapshot: int) -> PackedScene:
	match form_snapshot:
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

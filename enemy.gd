class_name Enemy
extends CharacterBody2D

@onready var anim := $AnimatedSprite2D
@onready var health_component := $HealthComponent
var spd := 50.0
@onready var hitbox_component: Node = $Hitbox/HitboxComponent
var stats: Stats
var frozen := false
var burning := false
var burning_timer := 0.0

const FREEZE_DURATION := 5.0

var anti_burn_tween: Tween
var anti_freeze_tween: Tween

var knockback = Vector2.ZERO
var knockback_recovery := 3.5

var is_elite = false
var is_boss = false
var freeze_immune = false

const MAX_OFFSCREEN_TIME := 10.0
var offscreen_time := 0.0
var is_offscreen := true
var despawn_immune = false

func _ready() -> void:
	stats = stats.create_instance()
	health_component.max_health = stats.max_health * Game.enemy_health_multi
	anim.sprite_frames = stats.sprite
	spd = stats.spd * randf_range(0.95, 1.05)
	knockback_recovery = stats.knockback_recovery
	Game.active_enemies += 1

	health_component.connect("died", die)
	health_component.connect("took_damage", flash)
	connect("tree_exiting", Callable(self, "_on_tree_exiting"))

func _on_tree_exiting() -> void:
	Game.active_enemies -= 1

func make_elite():
	knockback_recovery *= 2
	spd *= 0.8
	health_component.max_health *= 5
	#hitbox_component.percent_dmg += 1
	stats.drop_value *= 7
	scale *= 2
	is_elite = true

func make_boss():
	hitbox_component.percent_dmg += 2
	scale *= 3.5
	is_boss = true
	freeze_immune = true
	despawn_immune = true

func _physics_process(delta):
	if Game.player_is_dead:
		if !is_boss: die()
		else: return

	if !despawn_immune && is_offscreen:
		offscreen_time += delta
		if offscreen_time > MAX_OFFSCREEN_TIME:
			queue_free()
			print("despawned enemy")
			return
	else:
		offscreen_time = 0


	var player = get_tree().get_first_node_in_group("player")
	var dist = global_position.distance_to(player.global_position)
	var offset = remap(dist, 0, 500, 0, 100)
	var dir = global_position.direction_to(player.global_position + Vector2(randf_range(-offset, offset), randf_range(-offset, offset)))
	velocity = dir * spd

	# if dist > 1000:
	# 	print("despawned enemy")
	# 	queue_free()

	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	if knockback.length() > 0.0:
		velocity = knockback
	

	if frozen:
		velocity = Vector2.ZERO
	
	move_and_slide()

	if velocity.length() > 0:
		anim.play("default")
	else:
		anim.stop()

	if burning && burning_timer <= 0.0:
		var final_damage = Game.burn_damage
		if frozen:
			var damage_against_frozen := 0.0
			for upgrade in player.explosion_upgrades:
				if upgrade is DamageAgainstFrozen:
					damage_against_frozen += upgrade.increase
			final_damage *= 1 + damage_against_frozen
		health_component.take_damage(final_damage)
		Effects.spawn_damage_text(final_damage, global_position, Color.ORANGE)
		burning_timer = 1.0
	else:
		burning_timer -= delta

func get_knockbacked(dir: Vector2, amount: float) -> void:
	knockback = dir * amount

func die() -> void:
	if is_boss:
		Game.boss_died()


	var inst = preload("res://money_pickup.tscn").instantiate()
	inst.global_position = global_position
	inst.value = ceili(stats.drop_value * Game.money_multi)
	inst.type = stats.type
	get_tree().current_scene.get_node("%YSort").add_child(inst)
	if is_elite:
		inst.enable_shine()

	if randf() <= stats.health_drop_chance:
		inst = preload("res://health_pickup.tscn").instantiate()
		inst.global_position = global_position
		get_tree().current_scene.get_node("%YSort").add_child(inst)

	var death_anim = preload("res://Effects/death_animation.tscn")
	var death_inst = death_anim.instantiate()
	death_inst.global_position = global_position
	death_inst.scale = scale
	get_tree().current_scene.get_node("%YSort").add_child(death_inst)
	death_inst.set_sprite(stats.sprite)
	death_inst.play()

	var death_sfx_path = "res://Audio/sndEnemyDeath%s.mp3" % str(randi_range(1, 3))
	Utils.play_audio(load(death_sfx_path), 0.9, 1.1, 0.1)

	if randf() <= Game.burn_nova_on_kill && burning:
		var burn_nova = preload("res://Attacks/burn_nova.tscn").instantiate()
		burn_nova.position = global_position
		burn_nova.scale *= Game.burn_nova_scale_multi
		get_tree().current_scene.add_child(burn_nova)

	if randf() <= Game.freeze_nova_on_kill && frozen:
		var nova = preload("res://Attacks/freeze_nova.tscn").instantiate()
		nova.position = global_position
		get_tree().current_scene.add_child(nova)
	queue_free()

func flash() -> void:
	anim.material.set_shader_parameter("hit_flash_on", true)
	create_tween().tween_callback(func(): anim.material.set_shader_parameter("hit_flash_on", false)).set_delay(0.2)

func freeze() -> void:
	if freeze_immune:
		return

	frozen = true
	if anti_freeze_tween && anti_freeze_tween.is_running():
		anti_freeze_tween.kill()

	anim.modulate = Color(0, 0, 1, 1)
	anti_freeze_tween = create_tween()
	anti_freeze_tween.tween_property(anim, "modulate", Color(1, 1, 1, 1), FREEZE_DURATION).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	anti_freeze_tween.tween_callback(func(): frozen = false)

func burn() -> void:
	burning = true
	anim.material.set_shader_parameter("blink_time_scale", 4.0)
	if anti_burn_tween && anti_burn_tween.is_running():
		anti_burn_tween.kill()
	anti_burn_tween = create_tween()
	anti_burn_tween.tween_callback(func():
		burning=false
		anim.material.set_shader_parameter("blink_time_scale", 0.0)
		).set_delay(Game.burn_duration)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_offscreen = false


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	is_offscreen = true
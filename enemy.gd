class_name Enemy
extends CharacterBody2D

@onready var anim := $AnimatedSprite2D
@onready var health_component := $HealthComponent
var spd := 50.0

var stats: Stats
var frozen := false
var burning := false
var burning_timer := 0.0

const FREEZE_DURATION := 5.0
const BURN_DURATION := 3.0

var anti_burn_tween: Tween
var anti_freeze_tween: Tween


func _ready() -> void:
	stats = stats.create_instance()
	health_component.max_health = stats.max_health * Game.enemy_health_multi
	anim.sprite_frames = stats.sprite

	health_component.connect("died", die)
	health_component.connect("took_damage", flash)


func _physics_process(delta):
	var player = get_tree().get_first_node_in_group("player")
	var dir = global_position.direction_to(player.global_position)
	velocity = dir * spd

	if frozen:
		velocity = Vector2.ZERO
	
	move_and_slide()

	if velocity.length() > 0:
		anim.play("default")
	else:
		anim.stop()

	if burning && burning_timer <= 0.0:
		health_component.take_damage(Game.burn_damage)
		Effects.spawn_damage_text(Game.burn_damage, global_position, Color.ORANGE)
		burning_timer = 1.0
	else:
		burning_timer -= delta

func die() -> void:
	var inst = preload("res://money_pickup.tscn").instantiate()
	inst.global_position = global_position
	inst.value = stats.drop_value
	inst.type = stats.type
	get_tree().current_scene.get_node("%YSort").add_child(inst)

	var death_anim = preload("res://Effects/death_animation.tscn")
	var death_inst = death_anim.instantiate()
	death_inst.position = global_position - Vector2(0, 8)
	get_tree().current_scene.get_node("%YSort").add_child(death_inst)
	death_inst.set_sprite(stats.sprite)
	death_inst.play()

	var death_sfx_path = "res://Audio/sndEnemyDeath%s.mp3" % str(randi_range(1, 3))
	print("death_sfx_path: ", death_sfx_path)
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
	frozen = true
	if anti_freeze_tween && anti_freeze_tween.is_running():
		anti_freeze_tween.kill()

	anim.modulate = Color(0, 0, 1, 1)
	anti_freeze_tween = create_tween()
	anti_freeze_tween.tween_property(anim, "modulate", Color(1, 1, 1, 1), FREEZE_DURATION)
	anti_freeze_tween.tween_callback(func(): frozen = false)

func burn() -> void:
	burning = true

	if anti_burn_tween && anti_burn_tween.is_running():
		anti_burn_tween.kill()
	anti_burn_tween = create_tween()
	anti_burn_tween.tween_callback(func(): burning = false).set_delay(BURN_DURATION)

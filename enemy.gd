class_name Enemy
extends CharacterBody2D

@onready var anim := $AnimatedSprite2D
@onready var health_component := $HealthComponent
var spd := 50.0

var stats: Stats
var frozen := false

const FREEZE_DURATION := 5.0


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
	queue_free()

func flash() -> void:
	anim.material.set_shader_parameter("hit_flash_on", true)
	create_tween().tween_callback(func(): anim.material.set_shader_parameter("hit_flash_on", false)).set_delay(0.2)

func freeze() -> void:
	frozen = true
	anim.modulate = Color(0, 0, 1, 1)
	var anti_freeze_tween = create_tween()
	anti_freeze_tween.tween_property(anim, "modulate", Color(1, 1, 1, 1), FREEZE_DURATION)
	anti_freeze_tween.tween_callback(func(): frozen = false)

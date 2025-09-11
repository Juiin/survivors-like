class_name Player
extends CharacterBody2D

var spd := 150.0

@onready var anim := $AnimatedSprite2D
@onready var attack_timer := $AttackTimer
@onready var health_component := $HealthComponent

@export var stats: Stats

var ice_spear_scene := preload("res://ice_spear.tscn")
var explosion_scene := preload("res://explosion.tscn")


enum form {
	ST,
	AOE,
	DEF
}

var current_form: form = form.ST

func _ready() -> void:
	attack_timer.wait_time = 0.5
	attack_timer.start()
	attack_timer.timeout.connect(attack)
	
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
	var inst = get_attack_scene().instantiate()
	get_tree().current_scene.add_child(inst)

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
class_name Enemy
extends CharacterBody2D

@onready var anim := $AnimatedSprite2D
@onready var health_component := $HealthComponent
var spd := 50.0

@export var stats: Stats : set = set_stats

func set_stats(value: Stats) -> void:
    stats = value.create_instance()

func _ready() -> void:
    health_component.connect("died", die)
    health_component.connect("took_damage", flash)

func _physics_process(delta):
    var player = get_tree().get_first_node_in_group("player")
    var dir = global_position.direction_to(player.global_position)
    velocity = dir * spd
    
    move_and_slide()

    if velocity.length() > 0:
        anim.play("default")
    else:
        anim.stop()

func die() -> void:
    queue_free()

func flash() -> void:
    anim.material.set_shader_parameter("hit_flash_on", true)
    create_tween().tween_callback(func(): anim.material.set_shader_parameter("hit_flash_on", false)).set_delay(0.2)
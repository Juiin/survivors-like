class_name HealthPickup
extends Area2D

var pickup_snd = preload("res://Audio/eat.wav")
var spd := -2.0
var target: CharacterBody2D

var green_apple := preload("res://Textures/Items/apple_green.png")
var red_apple := preload("res://Textures/Items/apple_red.png")

var value := 40

@onready var sprite_2d: Sprite2D = $Sprite2D2

func _ready() -> void:
	sprite_2d.texture = [green_apple, red_apple].pick_random()

func _physics_process(delta: float) -> void:
	if target:
		global_position = global_position.move_toward(target.global_position, spd)
		spd += 5.2 * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Utils.play_audio(pickup_snd, 0.9, 1.1)
		body.health_component.heal(value)
		queue_free()

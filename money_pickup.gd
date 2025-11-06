class_name MoneyPickup
extends Area2D

var pickup_snd = preload("res://Audio/SoundEffect/collectgem.mp3")
var spd := -2.0
var target: CharacterBody2D

var ice_spear_sprite := preload("res://Textures/Items/Gems/Gem_blue.png")
var explosion_sprite := preload("res://Textures/Items/Gems/Gem_red.png")
var global_sprite := preload("uid://h5dy21n64hm6")

var value := 1
var type: Enums.UpgradeType = Enums.UpgradeType.EXPLOSION

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	scale *= 1.5
	if type == Enums.UpgradeType.GLOBAL:
		scale *= 1.6
	match type:
		Enums.UpgradeType.ICE_SPEAR:
			sprite_2d.texture = ice_spear_sprite
		Enums.UpgradeType.EXPLOSION:
			sprite_2d.texture = explosion_sprite
		Enums.UpgradeType.GLOBAL:
			sprite_2d.texture = global_sprite

func _physics_process(delta: float) -> void:
	if target:
		global_position = global_position.move_toward(target.global_position, spd)
		spd += 5.2 * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Utils.play_audio(pickup_snd, 0.9, 1.1, 0.35)
		Game.adjust_money(type, value)
		queue_free()

func enable_shine():
	sprite_2d.material.set_shader_parameter("shine_color", Color(1, 1, 1, 1))
class_name MoneyPickup
extends Area2D

var pickup_snd = preload("res://Audio/SoundEffect/collectgem.mp3")
var spd := -2.0
var target: CharacterBody2D

var ice_spear_sprite := preload("res://Textures/Items/Gems/Gem_blue.png")
var explosion_sprite := preload("res://Textures/Items/Gems/Gem_red.png")

var value := 1
var type: Enums.UpgradeType = Enums.UpgradeType.EXPLOSION

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	match type:
		Enums.UpgradeType.ICE_SPEAR:
			sprite_2d.texture = ice_spear_sprite
		Enums.UpgradeType.EXPLOSION:	
			sprite_2d.texture = explosion_sprite

func _physics_process(delta: float) -> void:
	if target:
		global_position = global_position.move_toward(target.global_position, spd)
		spd += 5.2 * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Utils.play_audio(pickup_snd, 0.9, 1.1)
		Game.adjust_money(type, value)
		queue_free()

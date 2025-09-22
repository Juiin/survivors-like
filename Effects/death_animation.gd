extends Node2D
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
func set_sprite(_sprite: SpriteFrames) -> void:
	sprite.sprite_frames = _sprite

func play() -> void:
	animation_player.speed_scale = randf_range(0.5, 1)
	animation_player.play("death")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()

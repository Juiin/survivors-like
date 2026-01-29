extends Node2D
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var particles: CPUParticles2D = $CPUParticles2D

func set_sprite(_sprite: SpriteFrames) -> void:
	sprite.sprite_frames = _sprite
	particles.texture = _sprite.get_frame_texture("default", 0)

func play() -> void:
	animation_player.speed_scale = randf_range(0.5, 1)
	animation_player.play("death")

func shatter() -> void:
	particles.emitting = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()


func _on_cpu_particles_2d_finished() -> void:
	queue_free()

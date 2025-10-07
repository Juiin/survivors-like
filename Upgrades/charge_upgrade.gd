extends Area2D

@onready var greyed_out: Sprite2D = $GreyedOut
@onready var fill: Sprite2D = $Fill

@export var upgrade: Upgrade

var charge := 0.0
var charge_up_tween: Tween
var charged_up := false
var audio_charge := preload("res://Audio/charge_up.mp3")
var audio_charge_player: AudioStreamPlayer

func _ready() -> void:
	greyed_out.texture = upgrade.charged_sprite
	fill.texture = upgrade.charged_sprite
	fill.scale = Vector2.ZERO

func _process(delta):
	if !charged_up:
		fill.scale = lerp(fill.scale, Vector2.ONE * charge, 0.1)

func _on_body_entered(body: Node2D) -> void:
	if charged_up:
		return

	audio_charge_player = Utils.play_audio_return(audio_charge, 0.9, 1.1, 0.7)

	charge_up_tween = create_tween()
	charge_up_tween.tween_property(self, "charge", 1.0, 5.0)
	charge_up_tween.tween_callback(has_charged_up)


func _on_body_exited(body: Node2D) -> void:
	charge_up_tween.kill()
	if audio_charge_player:
		audio_charge_player.queue_free()
	charge = 0

func has_charged_up() -> void:
	if charged_up:
		return

	charged_up = true
	if audio_charge_player:
		audio_charge_player.queue_free()
	Effects.spawn_floating_text(upgrade.upgrade_description, global_position)
	Utils.play_audio(preload("res://Audio/purchase.ogg"), 0.9, 1.1)
	var player = get_tree().get_first_node_in_group("player")
	upgrade.apply_player_upgrade(player)

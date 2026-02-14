extends HBoxContainer

var ice_spear_texture := preload("res://Textures/Items/Weapons/ice_spear.png")
var ice_spear_scene := preload("res://stored_ice_spear.tscn")

var recharging_child: Node
var recharge_progress: float = 0.0
var current_amount := 0

var played_rdy_sound := false

var player_color_tween: Tween

func _ready() -> void:
	recharging_child = get_child(0)

func _process(delta):
	if recharging_child:
		recharging_child.get_node("FillAmount").material.set_shader_parameter("progress", recharge_progress)
	var percent = current_amount * 0.33
	percent += remap(recharge_progress, 0.0, 1.0, 0.0, 0.33)
	percent = clamp(percent, 0.0, 1.0)
	owner.get_node("FreezeNovaIndicator").material.set_shader_parameter("progress", percent)
	var cur_color = owner.get_node("FreezeNovaIndicator").color_ramp.get_color(1)
	var new_color = cur_color
	new_color.a = Tween.interpolate_value(0.5, 1.0, percent, 1.0, Tween.TRANS_QUAD, Tween.EASE_IN)
	owner.get_node("FreezeNovaIndicator").color_ramp.set_color(1, new_color)

	if percent >= 1.0 && !played_rdy_sound:
		Utils.play_audio(load("res://Audio/freeze_nova_rdy.ogg"))
		played_rdy_sound = true
		owner.get_node("%FreezeNovaRdyParticles").emitting = true
		if player_color_tween:
			player_color_tween.kill()
		player_color_tween = create_tween()
		player_color_tween.tween_property(owner.get_node("AnimatedSprite2D"), "self_modulate", Color(0.25, 1.0, 1.0, 1.0), 0.4)

func update_count(amount: int) -> void:
	recharge_progress = 0.0
	recharging_child = null
	current_amount = amount
	if amount == 0:
		played_rdy_sound = false
		if player_color_tween:
			player_color_tween.kill()
		owner.get_node("AnimatedSprite2D").self_modulate = Color.WHITE
	var children = get_children()
	for i in children.size():
		var fill := children[i].get_node("%FillAmount")
		var mat: Material = fill.material

		if i < amount:
			# Fully charged spears
			mat.set_shader_parameter("progress", 1.0)
				

		elif i == amount:
			# Currently recharging spear
			recharging_child = children[i]
			recharge_progress = 0.0
			mat.set_shader_parameter("progress", recharge_progress)

		else:
			# Empty spears
			mat.set_shader_parameter("progress", 0.0)

		#only animate the latest one
		if i == amount - 1:
			var scale_tween = create_tween()
			scale_tween.tween_property(children[i], "scale", Vector2(1.5, 1.5), 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			scale_tween.tween_property(children[i], "scale", Vector2(1, 1), 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

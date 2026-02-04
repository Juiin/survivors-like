extends HBoxContainer

var ice_spear_texture := preload("res://Textures/Items/Weapons/ice_spear.png")
var ice_spear_scene := preload("res://stored_ice_spear.tscn")

var recharging_child: Node
var recharge_progress: float = 0.0
var current_amount := 0

func _ready() -> void:
	recharging_child = get_child(0)

func _process(delta):
	if recharging_child:
		recharging_child.get_node("FillAmount").material.set_shader_parameter("progress", recharge_progress)
	var percent = current_amount * 0.33
	percent += remap(recharge_progress, 0.0, 1.0, 0.0, 0.33)
	percent = clamp(percent, 0.0, 1.0)
	owner.get_node("FreezeNovaIndicator").material.set_shader_parameter("progress", percent)

func update_count(amount: int) -> void:
	recharge_progress = 0.0
	recharging_child = null
	current_amount = amount
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

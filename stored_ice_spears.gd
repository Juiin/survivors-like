extends HBoxContainer

var ice_spear_texture := preload("res://Textures/Items/Weapons/ice_spear.png")
var ice_spear_scene := preload("res://stored_ice_spear.tscn")


func update_count(amount: int) -> void:
	#clear old icons
	for child in get_children():
		child.queue_free()

	#add new ones
	for i in range(amount):
		var tex_rect = ice_spear_scene.instantiate()
		# if amount >= 3:
		# 	tex_rect.material.set_shader_parameter("layer_count", 3)
		# else:
		# 	tex_rect.material.set_shader_parameter("layer_count", 0)
		match i:
			0:
				tex_rect.material.set_shader_parameter("sample", preload("res://Textures/Particles/circle_022.png"))
				#tex_rect.material.set_shader_parameter("is_use_colors", false)
			1:
				tex_rect.material.set_shader_parameter("sample", preload("res://Textures/Particles/circle_02.png"))
				#tex_rect.material.set_shader_parameter("color_array", [Vector3(0.5, 1.0, 1.0)])
			_:
				tex_rect.material.set_shader_parameter("sample", preload("res://Textures/Particles/circle_0222.png"))

		#var tex_rect = TextureRect.new()
		# tex_rect.texture = ice_spear_texture
		# tex_rect.stretch_mode = TextureRect.STRETCH_KEEP
		# tex_rect.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		add_child(tex_rect)

		#only animate the latest one
		if i == amount - 1:
			var scale_tween = create_tween()
			scale_tween.tween_property(tex_rect, "scale", Vector2(1.5, 1.5), 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			scale_tween.tween_property(tex_rect, "scale", Vector2(1, 1), 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

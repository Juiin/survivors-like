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
		if amount >= 3:
			tex_rect.material.set_shader_parameter("layer_count", 3)
		else:
			tex_rect.material.set_shader_parameter("layer_count", 0)
		#var tex_rect = TextureRect.new()
		# tex_rect.texture = ice_spear_texture
		# tex_rect.stretch_mode = TextureRect.STRETCH_KEEP
		# tex_rect.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		add_child(tex_rect)

extends HBoxContainer

var ice_spear_texture := preload("res://Textures/Items/Weapons/ice_spear.png")


func update_count(amount: int) -> void:
	#clear old icons
	for child in get_children():
		child.queue_free()

	#add new ones
	for i in range(amount):
		var tex_rect = TextureRect.new()
		tex_rect.texture = ice_spear_texture
		tex_rect.stretch_mode = TextureRect.STRETCH_KEEP
		add_child(tex_rect)

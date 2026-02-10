class_name UpgradeEntry
extends PanelContainer

var upgrade_array: Array[Upgrade]
var upgrade_index: int

var upgrade: Upgrade

var extra_info: Node

func _ready() -> void:
	upgrade = upgrade_array[upgrade_index]

	%UpgradeName.text = upgrade.upgrade_name
	update_description()
	%BuyButton.text = str(upgrade.cost[upgrade.level])
	%UpgradeCount.text = get_upgrade_count_string()
	match upgrade.type:
		Enums.UpgradeType.ICE_SPEAR:
			%BuyButton.icon = preload("res://Textures/Items/Gems/Gem_blue.png")
		Enums.UpgradeType.EXPLOSION:
			%BuyButton.icon = preload("res://Textures/Items/Gems/Gem_red.png")
		Enums.UpgradeType.GLOBAL:
			%BuyButton.icon = preload("res://Textures/Items/Gems/Gem_blue_red.png")

	update_button_status()
	update_background_color()
	
	Game.ice_spear_money_changed.connect(update_button_status)
	Game.explosion_money_changed.connect(update_button_status)
	Game.ice_spear_money_changed.connect(update_description)
	Game.explosion_money_changed.connect(update_description)
	Game.ice_spear_money_changed.connect(update_background_color)
	Game.explosion_money_changed.connect(update_background_color)
	%UpgradeDescription.meta_hover_started.connect(_on_mouse_entered)
	%UpgradeName.meta_hover_started.connect(_on_mouse_entered)
	%UpgradeDescription.meta_hover_ended.connect(_on_mouse_exited)
	%UpgradeName.meta_hover_ended.connect(_on_mouse_exited)

func _on_mouse_entered(meta) -> void:
	if (upgrade.has_freeze_hint || upgrade.has_burn_hint) && !extra_info:
		extra_info = load("res://extra_info.tscn").instantiate()
		extra_info.global_position = get_global_mouse_position()
		extra_info.type = Enums.UpgradeType.ICE_SPEAR if upgrade.has_freeze_hint else Enums.UpgradeType.EXPLOSION
		get_tree().current_scene.get_node("UIRoot").add_child(extra_info)

func _on_mouse_exited(meta) -> void:
	if extra_info:
		extra_info.queue_free()
		extra_info = null

func _on_buy_button_pressed() -> void:
	if Game.enough_upgrade_cost(upgrade.type, upgrade.cost[upgrade.level]):
		upgrade.times_upgraded += 1
		upgrade.level += 1
		Game.adjust_money(upgrade.type, -upgrade.cost[upgrade.level - 1])
		Game.add_upgrade_to_player(upgrade.type, upgrade)
		Utils.play_audio(load("res://Audio/purchase.ogg"), 0.9, 1.1)
		var text = Effects.spawn_floating_text(upgrade.upgrade_name, get_global_mouse_position())
		text.process_mode = Node.PROCESS_MODE_ALWAYS
		text.reparent(get_tree().current_scene.get_node("%OverUI"))

		if !upgrade.endless && upgrade.times_upgraded > upgrade.level:
			queue_free()
		else:
			%BuyButton.text = str(upgrade.cost[upgrade.level])
			%UpgradeCount.text = get_upgrade_count_string()

func get_upgrade_count_string() -> String:
	var return_string = str(upgrade.times_upgraded) + "/"
	if upgrade.endless:
		%Infinity.visible = true
	else:
		return_string += str(upgrade.cost.size())
		%Infinity.visible = false
	return return_string

func update_button_status():
	%BuyButton.disabled = !Game.enough_upgrade_cost(upgrade.type, upgrade.cost[upgrade.level]) || !upgrade.is_unlocked()

func update_description():
	%UpgradeDescription.text = upgrade.upgrade_description if upgrade.is_unlocked() else upgrade.locked_description


func update_background_color():
	# Ice-blue (available)
	var default_col = Color(0.25, 0.55, 0.85) # icy blue
	default_col.a = 0.55

	if upgrade.type == Enums.UpgradeType.EXPLOSION:
		default_col = Color(0.55, 0.22, 0.14) # hot but not neon

	# Disabled (shared, neutral)
	var disabled_color = Color(0.45, 0.45, 0.45) # neutral gray
	disabled_color.a = 0.45

	# Locked (very muted, same for both)
	var locked_color = Color(0.12, 0.12, 0.14)
	locked_color.a = 0.15

	var final_col = disabled_color

	if Game.enough_upgrade_cost(upgrade.type, upgrade.cost[upgrade.level]):
		final_col = default_col

	if !upgrade.is_unlocked():
		final_col = locked_color

	get_theme_stylebox("panel").bg_color = final_col

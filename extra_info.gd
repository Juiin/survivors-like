extends PanelContainer

var move_in_offset := Vector2(0, 0)
var type: Enums.UpgradeType

@onready var label := %InfoText

func _ready() -> void:
	modulate.a = 0
	var fade_in_tween = create_tween()
	fade_in_tween.tween_property(self , "modulate:a", 1, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	var move_in_tween = create_tween()
	move_in_tween.tween_property(self , "move_in_offset", Vector2(0, 0), 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD).from(Vector2(0, -10))

	var col: Color
	match type:
		Enums.UpgradeType.ICE_SPEAR:
			label.text = "[color=#7fd4ff][b]Freeze[/b][/color]\n" + "Store 3+ Ice Spears, then cast one to trigger a freezing Nova, freezing enemies for 5 Seconds"
			col = Color(0.25, 0.55, 0.85)

		Enums.UpgradeType.EXPLOSION:
			label.text = "[color=#ff7a3a][b]Burn[/b][/color]\n" + "Hit enemies with Explosion or Burn Nova to inflict 1 damage per second for 3 seconds (base values)"
			col = Color(0.55, 0.32, 0.14)

	get_theme_stylebox("panel").bg_color = col

func _process(delta: float) -> void:
	var mouse_pos := get_global_mouse_position()
	var viewport_rect := get_viewport_rect()
	var tooltip_size := size
	var offset := Vector2(10, 0)
	# Check if tooltip would go off the right edge
	if mouse_pos.x + offset.x + tooltip_size.x > viewport_rect.size.x:
		offset.x = - tooltip_size.x - 10 # place left of cursor

	global_position = mouse_pos + offset + move_in_offset

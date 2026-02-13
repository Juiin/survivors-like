extends PanelContainer

var move_in_offset := Vector2(0, 0)
var type: Enums.UpgradeType

@onready var label := %InfoText

@export var adjust: bool = true

func _ready() -> void:
	if adjust:
		modulate.a = 0
		var fade_in_tween = create_tween()
		fade_in_tween.tween_property(self , "modulate:a", 1, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		var move_in_tween = create_tween()
		move_in_tween.tween_property(self , "move_in_offset", Vector2(0, 0), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD).from(Vector2(0, -10))

		var col: Color
		match type:
			Enums.UpgradeType.ICE_SPEAR:
				label.text = "How to [color=#7fd4ff][b]Freeze[/b][/color]\n" + "Store 3+ Ice Spears, then cast one to trigger a freezing Nova, freezing enemies for 5 Seconds"
				col = Color(0.25, 0.55, 0.85)

			Enums.UpgradeType.EXPLOSION:
				label.text = "How to [color=#ff7a3a][b]Burn[/b][/color]\n" + "Hit enemies with Explosion or Burn Nova to inflict 1 damage per second for 3 seconds (base values)"
				col = Color(0.55, 0.32, 0.14)

		get_theme_stylebox("panel").bg_color = col
	if has_node("Mover"):
		get_node("Mover").opened.connect(_opened)
		get_node("Mover").closed.connect(_closed)
	

func _opened():
	var fade_in_tween = create_tween()
	fade_in_tween.tween_property(self , "modulate:a", 1, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD).from(0)

func _closed():
	var fade_out_tween = create_tween()
	fade_out_tween.tween_property(self , "modulate:a", 0, 0.1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD).from(1)

func _process(delta: float) -> void:
	if adjust:
		var mouse_pos := get_global_mouse_position()
		var viewport_rect := get_viewport_rect()
		var tooltip_size := size
		var offset := Vector2(10, 0)
		# Check if tooltip would go off the right edge
		if mouse_pos.x + offset.x + tooltip_size.x > viewport_rect.size.x:
			offset.x = - tooltip_size.x - 10 # place left of cursor

		global_position = mouse_pos + offset + move_in_offset

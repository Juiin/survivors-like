extends Button

@onready var mover = $Mover
@onready var ui_root = %UIRoot
@onready var tab_sprite = $TabSprite

var in_menu := false

func _ready() -> void:
	pressed.connect(_on_pressed)

func set_to_upgrades() -> void:
	text = "Upgrades"

func set_to_resume() -> void:
	text = "Resume"

func _on_pressed() -> void:
	ui_root.toggle_menu()
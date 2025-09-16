extends Panel

@onready var explosion_money_text := %ExplosionMoneyText

func _ready():
	Game.explosion_money_changed.connect(update_label)
	update_label()

func update_label():
	explosion_money_text.text = str(Game.explosion_money)
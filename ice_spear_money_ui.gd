extends Panel

@onready var ice_spear_money_text := %IceSpearMoneyText

func _ready():
	Game.ice_spear_money_changed.connect(update_label)
	update_label()

func update_label():
	ice_spear_money_text.text = str(Game.ice_spear_money)
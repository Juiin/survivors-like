class_name DamageAgainstFrozen
extends Upgrade

@export var increase := 0.20


func _init():
	upgrade_name = "Against [url][color=#7fd4ff]Frozen[/color][/url]"
	upgrade_description = "20% increased damage against [url][color=#7fd4ff]frozen[/color][/url] enemies from Explosion, Burn Nova and Burn damage over time"
	cost = [25, 50, 75, 100, 125, 150, 175, 200, 225, 250, 275, 300, 325, 350, 375, 400, 425, 450, 475, 500]
	type = Enums.UpgradeType.EXPLOSION
	endless = true
	has_freeze_hint = true

func apply_upgrade(attack: Attack) -> void:
	attack.hitbox_component.damage_against_frozen += increase

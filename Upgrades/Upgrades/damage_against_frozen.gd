class_name DamageAgainstFrozen
extends Upgrade

@export var increase := 0.20


func _init():
	upgrade_name = "Against Frozen"
	upgrade_description = "20% increased damage against frozen enemies from Explosion, Burn Nova and Burn damage over time"
	cost = [25, 50, 75, 100, 125, 150, 175, 200, 225, 250, 275, 300, 325, 350, 375, 400, 425, 450, 475, 500]
	type = Enums.UpgradeType.EXPLOSION
	endless = true

func apply_upgrade(attack: Attack) -> void:
	attack.hitbox_component.damage_against_frozen += increase

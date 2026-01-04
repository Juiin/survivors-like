class_name DamageAgainstFrozen
extends Upgrade

@export var increase := 0.2


func _init():
	upgrade_name = "Against Frozen"
	upgrade_description = "20% increased damage against frozen enemies"
	cost = [25, 50, 75, 100, 125, 150, 175, 200, 225, 250]
	type = Enums.UpgradeType.EXPLOSION
	endless = true

func apply_upgrade(attack: Attack) -> void:
	attack.hitbox_component.damage_against_frozen += increase

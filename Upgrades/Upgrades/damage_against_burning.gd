class_name DamageAgainstBurning
extends Upgrade

@export var increase := 0.15


func _init():
	upgrade_name = "Against [color=#ff7a3a][url]Burning[/url][/color]"
	upgrade_description = "15% increased damage against [color=#ff7a3a][url]burning[/url][/color] enemies from Ice Spear and Ice Shard"
	cost = [50, 100, 150, 200, 250, 300, 350, 400, 450, 500]
	type = Enums.UpgradeType.ICE_SPEAR
	endless = true
	has_burn_hint = true

func apply_upgrade(attack: Attack) -> void:
	attack.hitbox_component.damage_against_burning += increase

class_name DamageUpgrade
extends Upgrade

@export var damage_increase := 10

func apply_upgrade(attack: Attack) -> void:
    attack.hitbox_component.damage += damage_increase
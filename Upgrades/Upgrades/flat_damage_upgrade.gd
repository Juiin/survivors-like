class_name FlatDamageUpgrade
extends Upgrade

var damage_increase := 10


func _init(_type: Enums.UpgradeType):
    upgrade_name = "Flat Damage"
    upgrade_description = "Increased Damage by %s"
    cost = [10]
    upgrade_description = upgrade_description % damage_increase
    type = _type

func apply_upgrade(attack: Attack) -> void:
    attack.hitbox_component.damage += damage_increase

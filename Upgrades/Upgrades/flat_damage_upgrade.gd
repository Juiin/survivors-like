class_name FlatDamageUpgrade
extends Upgrade

var damage_increase := 1


func _init(_type: Enums.UpgradeType):
    upgrade_name = "Flat Damage"
    upgrade_description = "Increases Damage by 1"
    cost = [25, 50, 75, 100, 125, 150]
    type = _type
    endless = true

func apply_upgrade(attack: Attack) -> void:
    attack.hitbox_component.flat_dmg += damage_increase

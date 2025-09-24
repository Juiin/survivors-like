class_name FlatDamageUpgrade
extends Upgrade

var damage_increase := 1


func _init(_type: Enums.UpgradeType):
    upgrade_name = "Flat Damage"
    upgrade_description = "Increases Damage by 1"
    cost = [100, 200, 350, 600, 1000, 2000, 4000, 8000, 16000, 32000]
    type = _type

func apply_upgrade(attack: Attack) -> void:
    attack.hitbox_component.flat_dmg += damage_increase

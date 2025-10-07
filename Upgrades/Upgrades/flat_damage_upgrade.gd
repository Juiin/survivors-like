class_name FlatDamageUpgrade
extends Upgrade

var damage_increase := 1


func _init(_type: Enums.UpgradeType):
    upgrade_name = "Flat Damage"
    upgrade_description = "Increases Damage by 1"
    cost = [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000]
    type = _type
    endless = true

func apply_upgrade(attack: Attack) -> void:
    attack.hitbox_component.flat_dmg += damage_increase

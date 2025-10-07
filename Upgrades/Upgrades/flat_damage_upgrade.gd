class_name FlatDamageUpgrade
extends Upgrade

var damage_increase := 1


func _init(_type: Enums.UpgradeType):
    upgrade_name = "Flat Damage"
    upgrade_description = "Increases Damage by 1"
    cost = [50, 75, 100, 125, 150, 175, 200, 225, 250, 275, 300, 325, 350, 375, 400, 425, 450, 475, 500]
    type = _type
    endless = true

func apply_upgrade(attack: Attack) -> void:
    attack.hitbox_component.flat_dmg += damage_increase

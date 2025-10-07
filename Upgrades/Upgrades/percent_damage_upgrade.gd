class_name PercentDamageUpgrade
extends Upgrade

var damage_increase := 0.1


func _init(_type: Enums.UpgradeType):
    upgrade_name = "% Damage"
    upgrade_description = "Increases Damage by 10%"
    cost = [50, 75, 100, 125, 150, 175, 200, 225, 250, 275, 300, 325, 350, 375, 400, 425, 450, 475, 500]
    type = _type
    endless = true

func apply_upgrade(attack: Attack) -> void:
    attack.hitbox_component.percent_dmg += damage_increase

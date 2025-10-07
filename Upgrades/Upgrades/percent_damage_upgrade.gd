class_name PercentDamageUpgrade
extends Upgrade

var damage_increase := 0.1


func _init(_type: Enums.UpgradeType):
    upgrade_name = "% Damage"
    upgrade_description = "Increases Damage by 10%"
    cost = [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000]
    type = _type
    endless = true

func apply_upgrade(attack: Attack) -> void:
    attack.hitbox_component.percent_dmg += damage_increase

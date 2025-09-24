class_name PercentDamageUpgrade
extends Upgrade

var damage_increase := 0.1


func _init(_type: Enums.UpgradeType):
    upgrade_name = "% Damage"
    upgrade_description = "Increases Damage by 10%"
    cost = [100, 200, 350, 600, 1000, 2000, 4000, 8000, 16000, 32000]
    type = _type

func apply_upgrade(attack: Attack) -> void:
    attack.hitbox_component.percent_dmg += damage_increase

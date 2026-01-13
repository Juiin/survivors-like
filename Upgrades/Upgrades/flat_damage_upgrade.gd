class_name FlatDamageUpgrade
extends Upgrade

var damage_increase := 1


func _init(_type: Enums.UpgradeType):
    upgrade_name = "Flat Damage"
    var str = ""
    match _type:
        Enums.UpgradeType.ICE_SPEAR:
            str = "of ice abilities"
        Enums.UpgradeType.EXPLOSION:
            str = "of fire abilities"
    upgrade_description = "Increases Damage " + str + " by 1"
    cost = [25, 50, 75, 100, 125, 150]
    type = _type
    endless = true

func apply_upgrade(attack: Attack) -> void:
    attack.hitbox_component.flat_dmg += damage_increase

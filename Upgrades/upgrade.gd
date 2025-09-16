class_name Upgrade
extends Resource

var upgrade_name: String = "Upgrade Name"
var upgrade_description: String = "Upgrade Description %s"
var cost: int = 10

var type: Enums.UpgradeType

func apply_upgrade(attack: Attack) -> void:
    pass

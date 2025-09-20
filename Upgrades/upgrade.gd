class_name Upgrade
extends Resource

var upgrade_name: String = "Upgrade Name"
var upgrade_description: String = "Upgrade Description %s"
var cost: Array[int] = [10]
var level := 0

var type: Enums.UpgradeType

func apply_upgrade(attack: Attack) -> void:
    pass

func apply_player_upgrade(player: Player) -> void:
    pass

func create_instance() -> Resource:
    var instance: Upgrade = self.duplicate()
    instance.level = level
    return instance
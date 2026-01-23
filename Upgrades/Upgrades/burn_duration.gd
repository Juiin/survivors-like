class_name BurnDurationUpgrade
extends Upgrade

@export var increase := 1.0

func _init():
    upgrade_name = "Burn Duration"
    upgrade_description = "+1 Second to Burn Duration"
    cost = [50, 75, 100, 125, 150]
    type = Enums.UpgradeType.EXPLOSION
    endless = true

func apply_player_upgrade(player: Player) -> void:
    Game.burn_duration += increase
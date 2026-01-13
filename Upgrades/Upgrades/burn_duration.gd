class_name BurnDurationUpgrade
extends Upgrade

@export var increase := 1.0

func _init():
    upgrade_name = "Burn Duration"
    upgrade_description = "+1 Second to Burn Duration"
    cost = [100, 150, 200, 250, 300, 350, 400, 450, 500]
    type = Enums.UpgradeType.EXPLOSION
    endless = true

func apply_player_upgrade(player: Player) -> void:
    Game.burn_duration += increase
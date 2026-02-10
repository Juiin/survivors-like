class_name BurnDurationUpgrade
extends Upgrade

@export var increase := 1.0

func _init():
    upgrade_name = "[color=#ff7a3a][url]Burn[/url][/color] Duration"
    upgrade_description = "+1 Second to [color=#ff7a3a][url]Burn[/url][/color] Duration"
    cost = [25, 35, 45, 50]
    type = Enums.UpgradeType.EXPLOSION
    endless = true
    has_burn_hint = true

func apply_player_upgrade(player: Player) -> void:
    Game.burn_duration += increase
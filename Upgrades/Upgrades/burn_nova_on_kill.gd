class_name BurnNovaOnKillUpgrade
extends Upgrade

@export var increase := 0.2

func _init():
    upgrade_name = "Burn Nova on Kill"
    upgrade_description = "20% chance to erupt a burning Nova when killing a burning enemy"
    cost = [55, 60, 61, 62, 63]
    type = Enums.UpgradeType.EXPLOSION

func apply_player_upgrade(player: Player) -> void:
    Game.burn_nova_on_kill += increase
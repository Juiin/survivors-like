class_name BurnNovaOnKillUpgrade
extends Upgrade

@export var increase := 0.1

func _init():
    upgrade_name = "Burn Nova on Kill"
    upgrade_description = "10% chance to erupt a burning Nova when killing a burning enemy, dealing 5 Damage"
    cost = [150, 350, 650, 1000, 1300, 1600, 2000, 2300, 2600, 3000]
    type = Enums.UpgradeType.EXPLOSION

func apply_player_upgrade(player: Player) -> void:
    Game.burn_nova_on_kill += increase
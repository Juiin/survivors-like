class_name BurnNovaOnKillUpgrade
extends Upgrade

@export var increase := 0.1

func _init():
    upgrade_name = "Burn Nova on Kill"
    upgrade_description = "10% chance to erupt a burning Nova when killing a burning enemy, dealing 5 Damage"
    cost = [200, 500, 800, 1200, 1600, 2000, 2500, 3000, 4500, 6000]
    type = Enums.UpgradeType.EXPLOSION

func apply_player_upgrade(player: Player) -> void:
    Game.burn_nova_on_kill += increase
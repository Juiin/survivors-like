class_name BurnNovaAoEUpgrade
extends Upgrade

@export var increase := 0.5

func _init():
    upgrade_name = "Burn Nova AoE"
    upgrade_description = "50% increased Burn Nova AoE"
    cost = [55, 60, 61, 62, 63]
    type = Enums.UpgradeType.EXPLOSION

func apply_player_upgrade(player: Player) -> void:
    Game.burn_nova_scale_multi += increase
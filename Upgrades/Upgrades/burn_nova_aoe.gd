class_name BurnNovaAoEUpgrade
extends Upgrade

@export var increase := 0.5

func _init(_req_upgrade: Upgrade):
    upgrade_name = "Burn Nova AoE"
    upgrade_description = "50% increased Burn Nova AoE"
    cost = [100, 250, 500, 750, 1000]
    type = Enums.UpgradeType.EXPLOSION
    req_upgrade = _req_upgrade
    endless = true

func apply_player_upgrade(player: Player) -> void:
    Game.burn_nova_scale_multi += increase
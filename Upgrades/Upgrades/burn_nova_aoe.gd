class_name BurnNovaAoEUpgrade
extends Upgrade

@export var increase := 0.15

func _init(_req_upgrade: Upgrade):
    upgrade_name = "[color=#ff7a3a][url]Burn[/url][/color] Nova AoE"
    upgrade_description = "15% increased [color=#ff7a3a][url]Burn[/url][/color] Nova AoE"
    cost = [100, 200, 350, 500, 800, 1000, 1500]
    type = Enums.UpgradeType.EXPLOSION
    req_upgrade = _req_upgrade
    endless = true
    has_burn_hint = true

func apply_player_upgrade(player: Player) -> void:
    Game.burn_nova_scale_multi += increase
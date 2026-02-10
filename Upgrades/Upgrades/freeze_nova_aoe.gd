class_name FreezeNovaAoEUpgrade
extends Upgrade

@export var increase := 0.25

func _init():
    upgrade_name = "[url][color=#7fd4ff]Freeze[/color][/url] Nova AoE"
    upgrade_description = "25% increased [url][color=#7fd4ff]Freeze[/color][/url] Nova AoE"
    cost = [150, 250, 350, 450, 600, 800, 1000, 1500]
    type = Enums.UpgradeType.ICE_SPEAR
    endless = true
    has_freeze_hint = true

func apply_player_upgrade(player: Player) -> void:
    Game.freeze_nova_scale_multi += increase
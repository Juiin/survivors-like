class_name FreezeNovaOnKillUpgrade
extends Upgrade

@export var increase := 0.1

func _init(_req_upgrade: Upgrade):
    upgrade_name = "[url][color=#7fd4ff]Freeze[/color][/url] Nova on Kill"
    upgrade_description = "10% chance to erupt a [url][color=#7fd4ff]freezing[/color][/url] Nova when killing a [url][color=#7fd4ff]frozen[/color][/url] enemy"
    cost = [100, 250, 350, 500, 750, 1000, 1250, 1500, 2000, 2500]
    type = Enums.UpgradeType.ICE_SPEAR
    has_freeze_hint = true
    #req_upgrade = _req_upgrade

func apply_player_upgrade(player: Player) -> void:
    Game.freeze_nova_on_kill += increase

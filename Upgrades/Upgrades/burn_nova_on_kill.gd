class_name BurnNovaOnKillUpgrade
extends Upgrade

@export var increase := 0.1

func _init():
    upgrade_name = "[color=#ff7a3a][url]Burn[/url][/color] Nova on Kill"
    upgrade_description = "10% chance to erupt a [color=#ff7a3a][url]burning[/url][/color] Nova when killing a [color=#ff7a3a][url]burning[/url][/color] enemy, dealing 5 Damage"
    cost = [150, 350, 600, 700, 800, 1000, 1500, 2000, 2500, 3000]
    type = Enums.UpgradeType.EXPLOSION
    has_burn_hint = true

func apply_player_upgrade(player: Player) -> void:
    Game.burn_nova_on_kill += increase
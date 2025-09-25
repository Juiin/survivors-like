class_name FreezeNovaOnKillUpgrade
extends Upgrade

@export var increase := 0.2

func _init(_req_upgrade: Upgrade):
    upgrade_name = "Freeze Nova on Kill"
    upgrade_description = "20% chance to erupt a freezing Nova when killing a frozen enemy"
    cost = [55, 60, 61, 62, 63]
    type = Enums.UpgradeType.ICE_SPEAR
    req_upgrade = _req_upgrade
    req_upgrade_level = 1

func apply_player_upgrade(player: Player) -> void:
    Game.freeze_nova_on_kill += increase

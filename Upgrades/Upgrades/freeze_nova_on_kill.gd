class_name FreezeNovaOnKillUpgrade
extends Upgrade

@export var increase := 0.1

func _init(_req_upgrade: Upgrade):
    upgrade_name = "Freeze Nova on Kill"
    upgrade_description = "10% chance to erupt a freezing Nova when killing a frozen enemy"
    cost = [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000]
    type = Enums.UpgradeType.ICE_SPEAR
    #req_upgrade = _req_upgrade

func apply_player_upgrade(player: Player) -> void:
    Game.freeze_nova_on_kill += increase

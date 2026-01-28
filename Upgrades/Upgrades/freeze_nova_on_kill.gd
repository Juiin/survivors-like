class_name FreezeNovaOnKillUpgrade
extends Upgrade

@export var increase := 0.1

func _init(_req_upgrade: Upgrade):
    upgrade_name = "Freeze Nova on Kill"
    upgrade_description = "10% chance to erupt a freezing Nova when killing a frozen enemy"
    cost = [100, 250, 350, 500, 750, 1000, 1250, 1500, 2000, 2500]
    type = Enums.UpgradeType.ICE_SPEAR
    #req_upgrade = _req_upgrade

func apply_player_upgrade(player: Player) -> void:
    Game.freeze_nova_on_kill += increase

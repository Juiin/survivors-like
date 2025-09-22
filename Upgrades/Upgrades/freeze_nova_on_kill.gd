class_name FreezeNovaOnKillUpgrade
extends Upgrade

@export var increase := 0.2

func _init():
    upgrade_name = "Freeze Nova on Kill"
    upgrade_description = "20% chance to erupt a freezing Nova when killing a frozen enemy"
    cost = [55, 60, 61, 62, 63]
    type = Enums.UpgradeType.ICE_SPEAR

func apply_player_upgrade(player: Player) -> void:
    Game.freeze_nova_on_kill += increase

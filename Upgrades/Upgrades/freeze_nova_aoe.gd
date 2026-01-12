class_name FreezeNovaAoEUpgrade
extends Upgrade

@export var increase := 0.25

func _init():
    upgrade_name = "Freeze Nova AoE"
    upgrade_description = "25% increased Freeze Nova AoE"
    cost = [100, 200, 350, 500, 750, 1000]
    type = Enums.UpgradeType.ICE_SPEAR

func apply_player_upgrade(player: Player) -> void:
    Game.freeze_nova_scale_multi += increase
class_name FreezeNovaAoEUpgrade
extends Upgrade

@export var increase := 0.25

func _init():
    upgrade_name = "Freeze Nova AoE"
    upgrade_description = "25% increased Freeze Nova AoE"
    cost = [150, 250, 350, 450, 600, 800, 1000, 1500]
    type = Enums.UpgradeType.ICE_SPEAR
    endless = true

func apply_player_upgrade(player: Player) -> void:
    Game.freeze_nova_scale_multi += increase
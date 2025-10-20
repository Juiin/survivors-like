class_name ExplosionCountUpgrade
extends Upgrade

@export var increase := 1

func _init():
    upgrade_name = "Additional Explosion"
    upgrade_description = "Explode an additional time"
    cost = [300, 400, 500, 700, 1000, 1500, 2000, 2250, 2500]
    type = Enums.UpgradeType.EXPLOSION

func apply_player_upgrade(player: Player) -> void:
    player.explosion_count += increase

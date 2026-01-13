class_name ExplosionCountUpgrade
extends Upgrade

@export var increase := 1

func _init():
    upgrade_name = "Additional Explosion"
    upgrade_description = "Explode an additional time"
    cost = [300, 500, 1000, 2000, 4000, 6000, 8000, 10000]
    type = Enums.UpgradeType.EXPLOSION

func apply_player_upgrade(player: Player) -> void:
    player.explosion_count += increase

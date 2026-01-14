class_name GlobalPercentDamageUpgrade
extends Upgrade

var damage_increase := 0.15


func _init():
    upgrade_name = "% Damage"
    upgrade_description = "Increases Damage by 15%"
    cost = [50, 75, 100, 125, 150, 175, 200, 225, 250, 275, 300, 325, 350, 375, 400, 425, 450, 475, 500]
    type = Enums.UpgradeType.GLOBAL
    endless = true
    charged_sprite = preload("uid://j4a5nyq3p7jn")

# func apply_upgrade(attack: Attack) -> void:
#     attack.hitbox_component.percent_dmg += damage_increase

func apply_player_upgrade(player: Player) -> void:
    player.global_percent_dmg_increase += damage_increase
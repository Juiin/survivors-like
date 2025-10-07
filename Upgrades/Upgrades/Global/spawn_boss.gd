class_name SpawnBossUpgrade
extends Upgrade


func _init(_req_upgrade: Upgrade):
	upgrade_name = "Spawn Boss"
	upgrade_description = "Do or die!"
	cost = [10000]
	type = Enums.UpgradeType.GLOBAL
	req_upgrade_level = 9
	req_upgrade = _req_upgrade

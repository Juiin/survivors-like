extends Attack

@onready var cpuparticles_2d: CPUParticles2D = $CPUParticles2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	for upgrade in player.explosion_upgrades.size():
		if player.explosion_upgrades[upgrade] is FlatDamageUpgrade:
			player.explosion_upgrades[upgrade].apply_upgrade(self)
		if player.explosion_upgrades[upgrade] is DamageAgainstFrozen:
			hitbox_component.damage_against_frozen += player.explosion_upgrades[upgrade].increase
	for upgrade in player.global_upgrades.size():
		if player.global_upgrades[upgrade] is GlobalPercentDamageUpgrade:
			hitbox_component.percent_dmg += player.global_upgrades[upgrade].damage_increase

	cpuparticles_2d.emitting = true
	var timer = Timer.new()
	timer.set_wait_time(cpuparticles_2d.lifetime)
	timer.set_one_shot(true)
	timer.connect("timeout", queue_free)
	add_child(timer)
	timer.start()
	

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("burn"):
		body.burn()

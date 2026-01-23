extends Area2D


const lifetime := 3

var die_tween: Tween
var fade_out_tween: Tween

var spd := 150.0

var base_scale = 0.5

@onready var hitbox_component := $HitboxComponent

func _ready():
	var player = get_tree().get_first_node_in_group("player")
	for upgrade in player.ice_spear_upgrades.size():
		if player.ice_spear_upgrades[upgrade] is FlatDamageUpgrade:
			hitbox_component.flat_dmg += player.ice_spear_upgrades[upgrade].damage_increase
		if player.ice_spear_upgrades[upgrade] is DamageAgainstBurning:
			hitbox_component.damage_against_burning += player.ice_spear_upgrades[upgrade].increase
		if player.ice_spear_upgrades[upgrade] is PierceUpgrade:
			hitbox_component.hit_limit += 1
	for upgrade in player.global_upgrades.size():
		if player.global_upgrades[upgrade] is GlobalPercentDamageUpgrade:
			hitbox_component.percent_dmg += player.global_upgrades[upgrade].damage_increase


	start_die_tween()
	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(base_scale * 1.5, base_scale * 1.5), 0.35).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(base_scale, base_scale), 0.35).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func start_die_tween():
	if die_tween:
		die_tween.kill()

	if fade_out_tween:
		fade_out_tween.kill()

	die_tween = create_tween()
	die_tween.tween_callback(die).set_delay(lifetime)

	modulate.a = 1
	fade_out_tween = create_tween()
	fade_out_tween.tween_property(self, "modulate:a", 0, lifetime * 0.1).set_delay(lifetime * 0.9)

	die_tween = create_tween()
	die_tween.tween_callback(die).set_delay(lifetime)

func die():
	queue_free()

func _physics_process(delta):
	var dir = Vector2.RIGHT.rotated(rotation)
	position += dir * spd * delta
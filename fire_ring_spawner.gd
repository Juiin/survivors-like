extends Node2D

var start_radius: float
var max_radius := 700
@export var shrink_speed: float = 50.0
@export var fire_width: float = 32.0 # width in pixels of one fire sprite
@export var min_radius: float = 325.0 # stop shrinking at this point
@export var damage_per_second_outside: float = 15.0

var current_radius: float
var fires: Array[Node2D] = []
var max_fire_count: int
var player: Node2D

func _ready():
	start_radius = min_radius / 2
	current_radius = start_radius
	player = get_tree().get_first_node_in_group("player")
	_update_fire_ring()

	# var update_fire_ring_timer = Timer.new()
	# update_fire_ring_timer.connect("timeout", _update_fire_ring)
	# update_fire_ring_timer.set_wait_time(0.1)
	# add_child(update_fire_ring_timer)
	# update_fire_ring_timer.start()

	var shrink_tween = create_tween()
	shrink_tween.tween_property(self, "current_radius", max_radius, 5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	shrink_tween.tween_callback(func():
		for fire in fires:
			fire.get_node("Hitbox").queue_free()
		Game.spawn_boss())
	shrink_tween.tween_property(self, "current_radius", min_radius, 120).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

	# Precompute max number of fires needed at start radius
	var circumference = TAU * max_radius
	max_fire_count = int(ceil(circumference / fire_width))

	# Pre-instantiate all fire nodes once
	for i in range(max_fire_count):
		var fire = Game.BOSS_FIRE.instantiate()
		fire.global_position = Vector2.ONE * 10000
		add_child(fire)
		fire.set_process(false)
		fire.get_node("CollisionShape2D").set_deferred("disabled", true)
		fire.scale *= 2
		fires.append(fire)

func _process(delta):
	_update_fire_ring()
	
func _update_fire_ring():
	# compute how many fires are visible right now
	var circumference = TAU * current_radius
	var visible_count = clamp(int(round(circumference / fire_width)), 1, max_fire_count)

	# Position and show only the required fires
	for i in range(max_fire_count):
		if i < visible_count:
			var angle = (float(i) / visible_count) * TAU
			var dir = Vector2(cos(angle), sin(angle))
			fires[i].global_position = global_position + dir * current_radius
			fires[i].rotation = angle + PI / 2
			fires[i].set_process(true)
			fires[i].visible = true
			fires[i].get_node("CollisionShape2D").set_deferred("disabled", false)
		else:
			fires[i].set_process(false)
			fires[i].visible = false
			fires[i].get_node("CollisionShape2D").set_deferred("disabled", true)
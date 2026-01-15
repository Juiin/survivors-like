extends TileMapLayer

const TILE_SIZE := Vector2i(16, 16)
const WORLD_SIZE := Vector2i(12800, 7200)

const WORLD_TILES := Vector2i(
	WORLD_SIZE.x / TILE_SIZE.x,
	WORLD_SIZE.y / TILE_SIZE.y
)

const DECOR_TILES: Array[Vector2i] = [
	Vector2i(0, 12),
	Vector2i(1, 12),
	Vector2i(4, 12),
	Vector2i(5, 12),
	Vector2i(22, 11),
	Vector2i(23, 11),
	Vector2i(24, 11),
	Vector2i(14, 11),
	Vector2i(15, 11),
	Vector2i(17, 11),
	Vector2i(16, 11),
]

@export var single_chance := 0.002
@export var cluster_chance := 0.0004
@export var cluster_min_tiles := 4
@export var cluster_max_tiles := 18

const DIRS := [
	Vector2i.LEFT,
	Vector2i.RIGHT,
	Vector2i.UP,
	Vector2i.DOWN,
]

func scatter_deco():
	for x in range(WORLD_TILES.x):
		for y in range(WORLD_TILES.y):
			if randf() < cluster_chance:
				_spawn_cluster(Vector2i(x, y))
				continue

			if randf() < single_chance:
				set_cell(Vector2i(x, y), 0, DECOR_TILES.pick_random())

func _spawn_cluster(start: Vector2i):
	var tile: Vector2i = DECOR_TILES.pick_random()
	var steps := randi_range(cluster_min_tiles, cluster_max_tiles)

	var pos := start
	for i in steps:
		if pos.x < 0 or pos.y < 0:
			break
		if pos.x >= WORLD_TILES.x or pos.y >= WORLD_TILES.y:
			break

		set_cell(pos, 0, tile)

		# Randomly wander
		pos += DIRS.pick_random()

func _ready():
	scatter_deco()
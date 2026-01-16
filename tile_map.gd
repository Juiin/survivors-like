extends TileMapLayer

const TILE_SIZE := Vector2i(32, 32)
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
	Vector2i(6, 12),
	Vector2i(7, 12),
	Vector2i(8, 12),
	Vector2i(9, 12),
	Vector2i(10, 12),
	Vector2i(11, 12),
	Vector2i(12, 12),
	Vector2i(15, 12),
	Vector2i(16, 12),
	Vector2i(10, 11),
	Vector2i(11, 11),
	Vector2i(12, 11),
	Vector2i(13, 11),
	Vector2i(14, 11),
	Vector2i(15, 11),
	Vector2i(16, 11),
	Vector2i(17, 11),
	Vector2i(18, 11),
	Vector2i(19, 11),
	Vector2i(20, 11),
	Vector2i(21, 11),
	Vector2i(22, 11),
	Vector2i(23, 11),
	Vector2i(24, 11),
	Vector2i(0, 13),
	Vector2i(1, 13),
	Vector2i(2, 13),
	Vector2i(4, 13),
	Vector2i(5, 13),
	Vector2i(6, 13),
	Vector2i(7, 13),
	Vector2i(8, 13),
	Vector2i(9, 13),
	Vector2i(10, 13),
	Vector2i(11, 13),
	Vector2i(12, 13),
	Vector2i(13, 13),
	Vector2i(14, 13),
	Vector2i(15, 13),
	Vector2i(16, 13),
	Vector2i(17, 13),
]

@export var single_chance := 0.005
@export var cluster_chance := 0.0008
@export var cluster_min_tiles := 2
@export var cluster_max_tiles := 15

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
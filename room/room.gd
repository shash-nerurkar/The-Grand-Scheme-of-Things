extends TileMap

onready var world = $"..";

var current_room := 0;
var current_pos := Vector2();
var padding_y := 40;
var lower_right = world_to_map(Vector2(1024, 610));

func _ready():
	randomize();

func next_room(type):
	current_pos.x += lower_right.x;
	var room_num = choose_room(type);
	current_room = room_num;
	for i in range(lower_right.x):
		for j in range(lower_right.y):
			if get_cell(i, j + padding_y*room_num) != -1:
# warning-ignore:narrowing_conversion
				set_cell(i + current_pos.x, j, get_cell(i, j + padding_y*room_num));
	next_level();

func choose_room(type):
	var num;
	if type == null:
		num = 10;
	elif type:
		num = (randi() % 3) + 7;
	else:
		num = randi() % 7;
	if num == current_room:
		num = choose_room(type);
	return num;

func next_level():
	world.plat_pos = [];
	world.desire_pos = [];
	match current_room:
		0:
			world.plat_pos.append([map_to_world(Vector2(6, 11)), map_to_world(Vector2(7, 11)), map_to_world(Vector2(8, 11))]);
			world.plat_pos.append([map_to_world(Vector2(9, 8)), map_to_world(Vector2(10, 8)), map_to_world(Vector2(11, 8))]);
			world.plat_pos.append([map_to_world(Vector2(12, 4))]);
			world.plat_pos.append([map_to_world(Vector2(21, 5)), map_to_world(Vector2(22, 5)), map_to_world(Vector2(23, 5))]);
			world.desire_pos.append([map_to_world(Vector2(11, 17))]);
			world.desire_pos.append([map_to_world(Vector2(19, 15))]);
		1:
			world.plat_pos.append([map_to_world(Vector2(16, 3)), map_to_world(Vector2(17, 3)), map_to_world(Vector2(18, 3))]);
			world.plat_pos.append([map_to_world(Vector2(23, 6)), map_to_world(Vector2(24, 6)), map_to_world(Vector2(25, 6))]);
			world.plat_pos.append([map_to_world(Vector2(27, 10)), map_to_world(Vector2(28, 10)), map_to_world(Vector2(29, 10)), map_to_world(Vector2(30, 10)), map_to_world(Vector2(31, 10))]);
			world.desire_pos.append([map_to_world(Vector2(13, 13)), map_to_world(Vector2(13, 14)), map_to_world(Vector2(13, 15)), map_to_world(Vector2(13, 16))]);
			world.desire_pos.append([map_to_world(Vector2(25, 18))]);
		2:
			world.plat_pos.append([map_to_world(Vector2(14, 9)), map_to_world(Vector2(15, 9)), map_to_world(Vector2(16, 9))]);
			world.plat_pos.append([map_to_world(Vector2(20, 6)), map_to_world(Vector2(21, 6)), map_to_world(Vector2(22, 6))]);
			world.desire_pos.append([map_to_world(Vector2(18, 9)), map_to_world(Vector2(19, 9)), map_to_world(Vector2(20, 9))]);
			world.desire_pos.append([map_to_world(Vector2(22, 11))]);
			world.desire_pos.append([map_to_world(Vector2(24, 14)), map_to_world(Vector2(25, 14)), map_to_world(Vector2(26, 14)), map_to_world(Vector2(27, 14))]);
		3:
			world.plat_pos.append([map_to_world(Vector2(20, 11)), map_to_world(Vector2(21, 11)), map_to_world(Vector2(22, 11)), map_to_world(Vector2(23, 11)), map_to_world(Vector2(24, 11))]);
			world.desire_pos.append([map_to_world(Vector2(16, 13)), map_to_world(Vector2(17, 13))]);
			world.desire_pos.append([map_to_world(Vector2(24, 14)), map_to_world(Vector2(25, 14)), map_to_world(Vector2(26, 14)), map_to_world(Vector2(27, 14))]);
		4:
			world.plat_pos.append([map_to_world(Vector2(18, 15)), map_to_world(Vector2(19, 15))]);
			world.plat_pos.append([map_to_world(Vector2(21, 13)), map_to_world(Vector2(22, 13)), map_to_world(Vector2(23, 13))]);
			world.plat_pos.append([map_to_world(Vector2(25, 10)), map_to_world(Vector2(26, 10)), map_to_world(Vector2(27, 10)), map_to_world(Vector2(28, 10)), map_to_world(Vector2(29, 10))]);
			world.desire_pos.append([map_to_world(Vector2(15, 16)), map_to_world(Vector2(15, 17))]);
			world.desire_pos.append([map_to_world(Vector2(19, 17)), map_to_world(Vector2(19, 18))]);
			world.desire_pos.append([map_to_world(Vector2(22, 18))]);
			world.desire_pos.append([map_to_world(Vector2(25, 17)), map_to_world(Vector2(26, 17))]);
		5:
			world.plat_pos.append([map_to_world(Vector2(7, 13)), map_to_world(Vector2(8, 13)), map_to_world(Vector2(9, 13))]);
			world.plat_pos.append([map_to_world(Vector2(12, 11)), map_to_world(Vector2(13, 11)), map_to_world(Vector2(14, 11))]);
			world.plat_pos.append([map_to_world(Vector2(16, 9)), map_to_world(Vector2(17, 9)), map_to_world(Vector2(18, 9)), map_to_world(Vector2(19, 9)), map_to_world(Vector2(20, 9))]);
			world.desire_pos.append([map_to_world(Vector2(12, 17)), map_to_world(Vector2(13, 17)), map_to_world(Vector2(14, 17)), map_to_world(Vector2(15, 17)), map_to_world(Vector2(16, 17))]);
			world.desire_pos.append([map_to_world(Vector2(22, 15)), map_to_world(Vector2(23, 14))]);
		6:
			world.plat_pos.append([map_to_world(Vector2(16, 9)), map_to_world(Vector2(17, 9)), map_to_world(Vector2(18, 9))]);
			world.plat_pos.append([map_to_world(Vector2(19, 8)), map_to_world(Vector2(20, 8)), map_to_world(Vector2(21, 8)), map_to_world(Vector2(22, 8)), map_to_world(Vector2(23, 8)), map_to_world(Vector2(24, 8)), map_to_world(Vector2(25, 8))]);
			world.desire_pos.append([map_to_world(Vector2(18, 9))]);
			world.desire_pos.append([map_to_world(Vector2(19, 8)), map_to_world(Vector2(20, 8)), map_to_world(Vector2(24, 8))]);
		7:
			world.plat_pos.append([map_to_world(Vector2(9, 17))]);
			world.plat_pos.append([map_to_world(Vector2(16, 15))]);
			world.plat_pos.append([map_to_world(Vector2(23, 13))]);
			world.desire_pos.append([map_to_world(Vector2(10, 16)), map_to_world(Vector2(10, 17))]);
			world.desire_pos.append([map_to_world(Vector2(17, 14)), map_to_world(Vector2(17, 15))]);
			world.desire_pos.append([map_to_world(Vector2(24, 12))]);
		8:
			world.plat_pos.append([map_to_world(Vector2(18, 4))]);
			world.desire_pos.append([map_to_world(Vector2(19, 4))]);
			world.desire_pos.append([map_to_world(Vector2(20, 4))]);
		9:
			world.plat_pos.append([map_to_world(Vector2(6, 13)), map_to_world(Vector2(7, 13))]);
			world.plat_pos.append([map_to_world(Vector2(12, 13)), map_to_world(Vector2(13, 13))]);
			world.plat_pos.append([map_to_world(Vector2(18, 13)), map_to_world(Vector2(19, 13))]);
			world.plat_pos.append([map_to_world(Vector2(24, 13)), map_to_world(Vector2(25, 13))]);
			world.desire_pos.append([map_to_world(Vector2(7, 13))]);
			world.desire_pos.append([map_to_world(Vector2(12, 13))]);
			world.desire_pos.append([map_to_world(Vector2(18, 13))]);
			world.desire_pos.append([map_to_world(Vector2(24, 13))]);
			world.desire_pos.append([map_to_world(Vector2(15, 7)), map_to_world(Vector2(16, 7)), map_to_world(Vector2(17, 7)), map_to_world(Vector2(18, 7)), map_to_world(Vector2(18, 6)), map_to_world(Vector2(18, 8)), map_to_world(Vector2(19, 7))]);

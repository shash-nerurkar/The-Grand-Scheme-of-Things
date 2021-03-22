extends Node2D

signal start_game

onready var player = $player;
onready var HUD = $HUD;
onready var truth = $truth;
onready var desire = $desire;
onready var goddess = $goddess;
onready var camera = $Camera2D;
onready var room = $room;
onready var hidden_tiles_container = $hidden_tiles_container;
onready var bkg_image = $bkg_image;
onready var bkg_image2 = $bkg_image2;
onready var level_trigger = $level_trigger;
onready var game_end_trigger = $game_end_trigger;
onready var desire_flower = $desire_flower;
onready var level_trigger_coll = $level_trigger/CollisionShape2D;
onready var time = $time;
onready var tween = $Tween;
onready var music = $music;


var plat_pos = [];
var desire_pos = [];
var current_pos_x := 0;
var to_move := true;

func _ready():
	randomize();
	player.set_physics_process(false);
	HUD.cutscene.texture = load('res://art/cutscene/Scene1.png');
	HUD.fade_in();
	yield(get_tree().create_timer(5), "timeout");
	HUD.fade_out();
	yield(get_tree().create_timer(1), "timeout");
	HUD.cutscene.texture = load('res://art/cutscene/Scene2.png');
	HUD.fade_in();
	yield(get_tree().create_timer(5), "timeout");
	HUD.fade_out();
	yield(get_tree().create_timer(1), "timeout");
	HUD.cutscene.hide();
	HUD.fade_in();
	yield(get_tree().create_timer(1), "timeout");
	start_cutscene();
	yield(self, 'start_game');
	music.playing = true;
	release_truth();

func start_cutscene():
	yield(get_tree().create_timer(1), 'timeout');
	desire_flower.play('default');
	tween.interpolate_property(desire_flower, 'position', Vector2(155, 396.7), Vector2(82.4, 493.6), 2, Tween.TRANS_LINEAR, Tween.EASE_IN);
	tween.start();
	yield(tween, 'tween_all_completed');
	tween.interpolate_property(desire_flower, 'modulate', Color(1, 1, 1, 1), Color(255, 255, 255, 1), 2, Tween.TRANS_LINEAR, Tween.EASE_IN);
	tween.interpolate_property(player, 'modulate', Color(1, 1, 1, 1), Color(255, 1, 1, 1), 2, Tween.TRANS_LINEAR, Tween.EASE_IN);
	tween.start();
	yield(tween, 'tween_all_completed');
	tween.interpolate_property(desire_flower, 'modulate', Color(255, 255, 255, 1), Color(1, 1, 1, 0), 2, Tween.TRANS_LINEAR, Tween.EASE_IN);
	tween.interpolate_property(player, 'modulate', Color(255, 1, 1, 1), Color(1, 1, 1, 1), 2, Tween.TRANS_LINEAR, Tween.EASE_IN);
	tween.start();
	yield(tween, 'tween_all_completed');
	tween.interpolate_property(goddess, 'scale', goddess.scale, Vector2(0.0001, 0.0001), 1, Tween.TRANS_LINEAR, Tween.EASE_IN);
	tween.start();
	yield(tween, 'tween_all_completed');
	goddess.room_init();
	yield(goddess, 'start_cutscene_ended');
	tween.interpolate_property(HUD.exp_bar_container, 'modulate', HUD.exp_bar_container.modulate, Color(1, 0.56, 0, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN);
	tween.interpolate_property(HUD.pause_button, 'modulate', HUD.pause_button.modulate, Color(1, 0.56, 0, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN);
	tween.start();
	yield(tween, 'tween_all_completed');
	player.set_physics_process(true);
	emit_signal('start_game');

func end_cutscene():
	player.set_physics_process(false);
	player.sprite.play('idle');
	tween.interpolate_property(HUD.exp_bar_container, 'modulate', HUD.exp_bar_container.modulate, Color(1, 0.56, 0, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN);
	tween.interpolate_property(HUD.pause_button, 'modulate', HUD.pause_button.modulate, Color(1, 1, 1, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN);
	tween.start();
	yield(tween, 'tween_all_completed');
	time.rect_position += Vector2(current_pos_x, 0);
	time.show();
	tween.interpolate_property(time, 'color', time.color, Color(0, 1, 0, 0.45), 1, Tween.TRANS_LINEAR, Tween.EASE_IN);
	tween.start();
	yield(tween, 'tween_all_completed');
	time.get_node("eyes").show();
	time.get_node("eyes").play('default');
	tween.interpolate_property(player, 'position', player.position, Vector2(current_pos_x + 616, 360), 2, Tween.TRANS_LINEAR, Tween.EASE_IN);
	tween.start();
	yield(tween, 'tween_all_completed');
	truth.final_init(Vector2(current_pos_x + 100, -100), Vector2(current_pos_x + 670, 225));
	yield(truth, "final_init_done");
	yield(get_tree().create_timer(2), "timeout");
	tween.interpolate_property(truth, 'position', truth.position, Vector2(current_pos_x + 100, -100), 2, Tween.TRANS_LINEAR, Tween.EASE_IN);
	tween.start();
	yield(tween, 'tween_all_completed');
	tween.interpolate_property(time, 'modulate', time.modulate, Color(1, 1, 1, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN);
	tween.start();
	yield(tween, 'tween_all_completed');
	time.hide();
	goddess.scale = Vector2(3, 3);
	goddess.get_node("particles").emitting = false;
	goddess.self_modulate.a = 1;
	tween.interpolate_property(goddess, 'position', Vector2(current_pos_x + 1016, -100), Vector2(current_pos_x + 1016, 160), 2, Tween.TRANS_LINEAR, Tween.EASE_IN);
	tween.start();
	yield(tween, 'tween_all_completed');
	tween.interpolate_property(player, 'position', player.position, Vector2(current_pos_x + 885, 150), 2, Tween.TRANS_LINEAR, Tween.EASE_IN);
	tween.start();
	yield(tween, 'tween_all_completed');
	tween.interpolate_property(player, 'modulate', Color(1, 1, 1, 1), Color(1, 1, 1, 0), 2, Tween.TRANS_LINEAR, Tween.EASE_IN);
	tween.start();
	yield(tween, 'tween_all_completed');
	HUD.fade_out();
	yield(get_tree().create_timer(1), "timeout");
	HUD.cutscene.show();
	HUD.cutscene.texture = load('res://art/cutscene/Scene3_' + String(2 if player.experience == 100 else 1) + '.png');
	HUD.fade_in();
	yield(get_tree().create_timer(5), "timeout");
	HUD.fade_out();
	yield(get_tree().create_timer(1), "timeout");
	HUD.fade_in();
	yield(get_tree().create_timer(1), "timeout");
	HUD.get_node("endgame_panel").show();

func release_truth():
	room.next_level();
	truth.room_init(Vector2(current_pos_x, randi() % 600), plat_pos);
	tween.interpolate_property(HUD.screen_stat.get_material(), "shader_param/contrast", 2, 3, 2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(Engine, 'time_scale', 1, 0.5, 2, Tween.TRANS_CUBIC, Tween.EASE_IN);
	tween.interpolate_property(camera, 'zoom', Vector2(1, 1), Vector2(0.9, 0.9), 2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT);
	tween.start();

func release_desire():
	desire.room_init(player.position, desire_pos);

func update_exp(amt):
	player.experience += amt;
	HUD.update_exp_bar(true if sign(amt) == 1 else false, player.experience);

func _on_truth_path_completed():
	tween.interpolate_property(HUD.screen_stat.get_material(), "shader_param/contrast", 3, 2, 2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(Engine, 'time_scale', 0.5, 1, 2, Tween.TRANS_CUBIC, Tween.EASE_IN);
	tween.interpolate_property(camera, 'zoom', Vector2(0.9, 0.9), Vector2(1, 1), 2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT);
	tween.start();
	yield(tween, "tween_all_completed");
	release_desire();

func level_completed():
	HUD.pause_button.disabled = true;
	current_pos_x += 1024;
	if player.experience > 70 or player.experience < -70:
		update_exp(100*sign(player.experience) - player.experience);
	else:
		update_exp(randi()%60 - 30);
	if abs(player.experience) == 100:
		room.next_room(null);
	elif player.experience >= 70:
		room.next_room(true);
	else:
		room.next_room(false);
	(bkg_image2 if to_move else bkg_image).rect_position = Vector2(current_pos_x, 0);
	to_move = not to_move;
	tween.interpolate_property(camera, 'position', camera.position, camera.position + Vector2(1024, 0), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT);
	tween.start();
	if abs(player.experience) != 100:
		level_trigger.position += Vector2(1024, 0);
		level_trigger_coll.set_deferred('disabled', false);
	else:
		game_end_trigger.position = Vector2(current_pos_x + 300, 300);
		game_end_trigger.get_node("CollisionShape2D").set_deferred('disabled', false);
	player.room_pos = Vector2(current_pos_x, 0);
	yield(tween, 'tween_all_completed');
	HUD.pause_button.disabled = false;
	if abs(player.experience) != 100: 
		release_truth();

func add_hidden_tile(pos, type):
	var col_rect = ColorRect.new();
	col_rect.rect_size = Vector2(32,32);
	col_rect.rect_position = pos;
	col_rect.color.a = 0;
	hidden_tiles_container.add_child(col_rect);
	col_rect.add_child(Tween.new());
	var col = Color(1, 0.45, 0) if type else Color(1, 0, 0.1);
	col_rect.get_child(0).interpolate_property(col_rect, 'color', Color(col.r, col.g, col.b, 0), Color(col.r, col.g, col.b, 0.5), 1, Tween.TRANS_LINEAR, Tween.EASE_IN);
	col_rect.get_child(0).start();

# warning-ignore:unused_argument
func _on_level_trigger_body_entered(body):
	level_trigger_coll.set_deferred('disabled', true);
	level_completed();

func restart_room():
	HUD.fade_out();
	player.position = Vector2(20, 375) + Vector2(current_pos_x, 0);
	yield(get_tree().create_timer(1), 'timeout');
	for i in hidden_tiles_container.get_children():
		i.queue_free();
	player.show();
	player.set_physics_process(true);
	HUD.fade_in();
	yield(get_tree().create_timer(1), 'timeout');
	release_truth();

# warning-ignore:unused_argument
func _on_game_end_trigger_body_entered(body):
	end_cutscene();

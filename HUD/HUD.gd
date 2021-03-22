extends CanvasLayer

onready var exp_bar_container = $HBoxContainer;
onready var health_tween = $HBoxContainer/Tween;
onready var neg_exp_bar = $HBoxContainer/neg_experience;
onready var pos_exp_bar = $HBoxContainer/pos_experience;
onready var cutscene = $CanvasLayer2/cutscene;

var current_exp_type := true;
var change_bar;

func update_exp_bar(exp_type, dest_val):
	if exp_type != current_exp_type:
		health_tween.interpolate_property(pos_exp_bar if current_exp_type else neg_exp_bar, 'value', (pos_exp_bar if current_exp_type else neg_exp_bar).value, 0, 1, Tween.TRANS_LINEAR, Tween.EASE_IN);
		health_tween.start();
		current_exp_type = not current_exp_type;
		change_bar = dest_val;
	else:
		health_tween.interpolate_property(pos_exp_bar if current_exp_type else neg_exp_bar, 'value', (pos_exp_bar if current_exp_type else neg_exp_bar).value, dest_val * (1 if current_exp_type else -1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN);
		health_tween.start();
		exp_bar_container.modulate = Color(1, 0.45, 0) if current_exp_type else Color(1, 0, 0);
		change_bar = null;

# warning-ignore:unused_argument
func _on_Tween_tween_completed(object, key):
	if key == ':value':
		if change_bar != null:
			health_tween.interpolate_property(pos_exp_bar if current_exp_type else neg_exp_bar, 'value', (pos_exp_bar if current_exp_type else neg_exp_bar).value, change_bar * (1 if current_exp_type else -1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN);
			health_tween.start();
			exp_bar_container.modulate = Color(1, 0.45, 0) if current_exp_type else Color(1, 0, 0);
			change_bar = null;

onready var pause_panel = $CanvasLayer/MarginContainer;
onready var screen_stat = $CanvasLayer/screen_stat;
onready var pause_button = $CanvasLayer2/pause_button;

func _on_pause_button_pressed():
	get_tree().paused = true;
	pause_panel.show();
	screen_stat.show();
	screen_stat.material.set_shader_param('contrast', 1.5);
	screen_stat.material.set_shader_param('saturation', 0.3);

func _on_resume_button_pressed():
	get_tree().paused = false;
	pause_panel.hide();
	screen_stat.hide();

onready var transition = $CanvasLayer3/transition;
onready var trans_tween = $CanvasLayer3/transition/Tween;

func fade_out():
	transition.show();
	trans_tween.interpolate_property(transition, 'color', Color(0, 0, 0, 0), Color(0, 0, 0, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN);
	trans_tween.start();

func fade_in():
	trans_tween.interpolate_property(transition, 'color', Color(0, 0, 0, 1), Color(0, 0, 0, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN);
	trans_tween.start();
	yield(get_tree().create_timer(1), 'timeout');
	transition.hide();

func _on_game_finish_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://main_menu/main_menu.tscn");

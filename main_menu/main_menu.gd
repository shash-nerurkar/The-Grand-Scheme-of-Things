extends Control

func _ready():
	OS.window_fullscreen = true;

func _on_play_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://world/world.tscn");

func _on_quit_pressed():
	get_tree().quit();

extends Area2D

signal path_completed
signal add_hidden_tile
signal final_init_done

onready var eyes = $eyes;
onready var particles = $particles;
onready var move_tween = $Tween;
onready var collision = $CollisionShape2D;
onready var world = $'..';

var vel := Vector2();
var speed := 200;
var index := 0;
var dest_arr;

func room_init(pos, plat_pos):
	position = pos;
	dest_arr = plat_pos;
	for i in range(dest_arr.size()):
		for j in range(dest_arr[i].size()):
			dest_arr[i][j] += Vector2(world.current_pos_x, 0);
	index = 0;
	modulate.a = 1;
	particles.emitting = true;
	particles.lifetime = 1;
	move_tween.interpolate_property(self, 'vel', Vector2(1, 0), (dest_arr[index][dest_arr[index].size()/2] - position).normalized(), 1, Tween.TRANS_LINEAR, Tween.EASE_IN);
	move_tween.start();
	collision.set_deferred('disabled', false);
	set_physics_process(true);

func final_init(pos, dest_pos):
	modulate.a = 1;
	particles.emitting = true;
	particles.lifetime = 1;
	move_tween.interpolate_property(self, 'position', pos, dest_pos, 3, Tween.TRANS_LINEAR, Tween.EASE_IN);
	move_tween.start();

func disable():
	particles.emitting = false;
	move_tween.interpolate_property(self, 'modulate', modulate, Color(modulate.r, modulate.g, modulate.b, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN);
	move_tween.start();
	collision.set_deferred('disabled', true);
	set_physics_process(false);

func _physics_process(delta):
	position += vel*delta*speed;

# warning-ignore:unused_argument
func _on_Area2D_body_entered(body):
	if position.distance_to(dest_arr[index][dest_arr[index].size()/2]) <= 50:
		if index != dest_arr.size() - 1:
			for pos in dest_arr[index]:
				emit_signal('add_hidden_tile', pos, true);
			particles.lifetime -= 1/float(dest_arr.size());
			index += 1;
			move_tween.stop_all();
			move_tween.interpolate_property(self, 'vel', vel, (dest_arr[index][dest_arr[index].size()/2] - position).normalized(), 1, Tween.TRANS_LINEAR, Tween.EASE_IN);
			move_tween.start();
		else:
			for pos in dest_arr[index]:
				emit_signal('add_hidden_tile', pos, true);
			disable();

func _on_Tween_tween_completed(object, key):
	if object == self and key == ':vel':
		move_tween.interpolate_property(self, 'vel', vel, (dest_arr[index][dest_arr[index].size()/2] - position).normalized(), 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN);
		move_tween.start();
	elif object == self and key == ':modulate':
		emit_signal('path_completed');
	elif object == self and key == ':position':
		particles.process_material.gravity.y = 100;
		emit_signal('final_init_done');

extends KinematicBody2D

signal restart_room

onready var sprite = $sprite;
onready var collision = $collision;
onready var world = $'..';

export var vel := Vector2();
var speed := 350;
var gravity = 20;
var max_gravity := 300;
var jump_speed := 550;
var up_dir := Vector2(0, -1);
var room_pos := Vector2();
var emotion;
var experience := 0;
var max_jumps := 0;

# warning-ignore:unused_argument
func init(pos):
	show();
	collision.set_deferred('disabled', false);
	position = Vector2(20,20);
	set_physics_process(true);

func disable():
	hide();
	vel = Vector2();
	collision.set_deferred('disabled', true);
	set_physics_process(false);

# warning-ignore:unused_argument
func _physics_process(delta):
	if Input.is_action_pressed("player_left"):
		vel = vel.linear_interpolate(Vector2((-1*speed), vel.y), delta);
		sprite.flip_h = true;
		if ((experience >= -50) and (experience <= 40)):
			play('run');
		elif (experience < -50):
			play('shackled_walk');
		elif (experience > 40):
			play('walk');
	elif Input.is_action_pressed("player_right"):
		vel = vel.linear_interpolate(Vector2((1*speed), vel.y), delta);
		sprite.flip_h = false;
		if ((experience >= -50) and (experience <= 40)):
			play('run');
		elif (experience < -50):
			play('shackled_walk');
		elif (experience > 40):
			play('walk');
	else:
		vel = vel.linear_interpolate(Vector2(0, vel.y), delta * 15);
		play('idle');
	
	if Input.is_action_just_pressed("player_up") and is_on_floor():
		vel.y = -1 * jump_speed;
		max_jumps += 1
		if experience < -50:
			play('shackled_jump');
		else:
			play('jump');
	elif is_on_ceiling():
		vel.y = (gravity / 0.4);
	elif not is_on_floor():
		vel.y += gravity;
		vel.y = clamp(vel.y, -1*jump_speed, max_gravity);
	else:
		vel.y = gravity;
		if sprite.animation == 'death': set_physics_process(false);
	if (Input.is_action_just_pressed("player_up") and (not is_on_floor()) and (max_jumps < 2)):
		vel.y = -1 * (jump_speed / 1.3);
		max_jumps += 1
	wrap();
# warning-ignore:return_value_discarded
	move_and_slide(vel, up_dir);

func play(anim):
	if anim == 'jump' or anim == 'shackled_jump' or anim == 'death':
		sprite.play(anim);
	else:
		if sprite.animation == 'jump' or sprite.animation == 'shackled_jump':
			if is_on_floor():
				max_jumps = 0;
				sprite.play(anim);
		elif sprite.animation == 'death':
			return;
		else:
			sprite.play(anim);
 
func wrap():
	if position.x < room_pos.x + collision.shape.extents.x:
		position.x = room_pos.x + collision.shape.extents.x;
	elif position.x > room_pos.x + 1024 - collision.shape.extents.x:
		position.x = room_pos.x + 1024 - collision.shape.extents.x;
	if position.y < room_pos.y + collision.shape.extents.y:
		position.y = room_pos.y + collision.shape.extents.y;
	elif position.y > room_pos.y + 600 - collision.shape.extents.y:
		hide();
		set_physics_process(false);
		emit_signal('restart_room');

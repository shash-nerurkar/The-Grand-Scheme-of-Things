extends Particles2D

signal start_cutscene_ended

onready var move_tween = $Tween;

var vel := Vector2();
var speed := 400;

func room_init():
	$'..'.self_modulate.a = 0;
	emitting = true;
	move_tween.interpolate_property(self, 'vel', Vector2(1, 0), Vector2(0, -1), 2, Tween.TRANS_LINEAR, Tween.EASE_IN);
	move_tween.start();
	set_physics_process(true);

func _ready():
	set_physics_process(false);

func _physics_process(delta):
	global_position += vel*delta*speed;
	if global_position.y < -300:
		emit_signal('start_cutscene_ended');
		set_physics_process(false);

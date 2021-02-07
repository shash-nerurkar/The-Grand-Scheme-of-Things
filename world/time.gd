extends AnimatedSprite

onready var timer = $Timer;

var vel := Vector2();
var dest := Vector2();

func _ready():
	set_physics_process(false);
	timer.stop();

func _physics_process(delta):
	vel = vel.linear_interpolate((dest - position).normalized(), delta);
	position += vel*100*delta;
	if position.distance_to(dest) <= 50 and timer.is_stopped():
		timer.start();

func _on_Timer_timeout():
	dest = Vector2(randi() % 1024, randi() % 600);

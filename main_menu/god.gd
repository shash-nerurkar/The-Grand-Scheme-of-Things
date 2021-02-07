extends Particles2D

export var index := 0;

var vel := Vector2();

var rot_val := [Vector2(1, 0), Vector2(0, 1), Vector2(-1, 0), Vector2(0, -1)];

func _ready():
	$Tween.interpolate_property(self, 'vel', Vector2(), rot_val[index], 1, Tween.TRANS_LINEAR, Tween.EASE_IN);
	$Tween.start();

func _physics_process(delta):
	print(get_name() + ': ' + String(vel));
	position += vel*delta*300;

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_Tween_tween_completed(object, key):
	index = index + 1 if index < 3 else 0;
	$Tween.interpolate_property(self, 'vel', vel, rot_val[index], 1, Tween.TRANS_LINEAR, Tween.EASE_IN);
	$Tween.start();

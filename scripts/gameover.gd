extends Node2D


var speed=0.7

func _ready():
	position -= Vector2(0,600)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y +=delta*Vector2(0,0).distance_to(position)*4
	$Control/ColorRect.color.a-=clamp(delta*speed,0.01*delta,100*delta)
	speed-=delta*speed
	if $Control/ColorRect.color.a<0.1:
		$Control/ColorRect.color.a=0.1
	pass

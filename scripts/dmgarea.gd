extends Area2D
var shape=CircleShape2D.new()
var speed=2
var maxx=1
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	scale=Vector2(0,0)
	$CollisionShape2D.shape=shape
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	scale+=Vector2(1,1)*delta*speed
	if scale>Vector2(maxx,maxx):
		queue_free()
	for e in get_overlapping_bodies():
		if e is enemy:
			e.damage(80*delta*2)
	pass

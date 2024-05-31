extends Node2D

var veloc=Vector2(-5,0)
var direction=Vector2(1,1)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position+=veloc*2*delta
	if veloc.x>=10:
		direction.x=-1
	if veloc.x<=-10:
		direction.x=1
	if veloc.y>=10:
		direction.y=-1
	if veloc.y<=-10:
		direction.y=1
	veloc+=direction*2*delta
	pass

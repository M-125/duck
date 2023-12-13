extends Node2D
var veloc=150
var wait=1
var random
var fallspeed=100
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	random=rand_range(-20,20)*2
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if wait<0:
		modulate.a8-=255*delta
	wait-=delta
	veloc-=delta*fallspeed
	position.y-=veloc*delta
	position.x+=random*delta*2
	fallspeed+=5
	if modulate.a<=0:
		queue_free()
	pass

extends Node2D
class_name damagemeter
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
	name="damagemeter"+str(random)
	
	pass # Replace with function body.

func setdmg(num:int):
	$Label.text=str(num)
func getdmg():
	return int($Label.text)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if wait<0:
		modulate.a8-=255*delta
		
	wait-=delta
	veloc-=delta*fallspeed
	position.y-=veloc*delta
	position.x+=random*delta*2
	fallspeed+=3
	if modulate.a<=0:
		queue_free()
	pass
			

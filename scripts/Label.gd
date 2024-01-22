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
func trymerge():
	if wait<0.2:for e in get_parent().get_children():
		if "damagemeter" in e.name and position.distance_to(e.position)<500 and e != self:
			var dmg=load("res://scenes/damagemeter.tscn").instance()
			dmg.get_node("Label").text=str(int($Label.text)+int(e.get_node("Label").text))
			dmg.position=e.position+position
			dmg.position/=2
			get_parent().add_child(dmg)
			queue_free()
			e.queue_free()
			

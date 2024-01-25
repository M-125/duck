extends Node
class_name merger
signal merge
var timer=0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("merge",self,"merge")
	merge()
	pass # Replace with function body.

func merge():
	for e in get_parent().get_children():
		if is_instance_valid(e) and e is damagemeter and e.wait<0.7:
			for i in get_parent().get_children():
				if i!=e and i is damagemeter and e.position.distance_to(i.position)<600 and i.wait<0.5:
					var counter=preload("res://scenes/damagemeter.tscn").instance()
					counter.modulate=Color(0.5,0.55,0.5)
					counter.fallspeed=250
					counter.position=(i.position+e.position)/2
					counter.setdmg(e.getdmg()+i.getdmg())
					get_parent().add_child(counter)
					e.queue_free()
					i.queue_free()
					break
			yield(get_tree(),"idle_frame")
	yield(get_tree(),"idle_frame")
	timer=0
	emit_signal("merge")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer+=delta
	if timer > 10:
		emit_signal("merge")
		

extends Area2D
class_name custombutton
var cursor
var wait=0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	for e in get_parent().get_children():
		if e.name=="cursor":
			cursor=e
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var curs
	curs=overlaps_area(cursor)
#	curs=false
	
	if wait<=0:
		if (Input.is_action_just_pressed("righthand")) and curs:
			while not Input.is_action_just_released("righthand"):
				set_process(false)
				yield(get_tree(),"idle_frame")
			set_process(true)
			if curs:
				emit_signal("pressed")
#			queue_free()
				wait=0.3
	wait-=delta
	pass

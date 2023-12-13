extends AudioStreamPlayer
class_name sound
export(float) var length=1.2
export(bool) var randompitch=false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("finished",self,"finished")
	if randompitch:
		pitch_scale=rand_range(1,1.2)
	yield(get_tree().create_timer(length),"timeout")
	queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func finished():
	queue_free()
	pass # Replace with function body.

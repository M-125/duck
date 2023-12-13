extends ColorRect
var phase=-1
var time=1
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time-=delta
	if phase==0:
		get_parent().position.x+=2000
	if phase==1:
		get_parent().position.x-=2000
	if phase==30:
		queue_free()
	if time<0:
		phase+=1
#	pass


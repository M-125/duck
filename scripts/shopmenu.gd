extends Node2D
signal bought

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.guistate=Global.guistates.gui1

func _process(d):
	if Global.guistate<Global.guistates.gui1:
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


	pass # Replace with function body.


func leaveshop():
	queue_free()
	Global.guistate-=1
	pass # Replace with function body.

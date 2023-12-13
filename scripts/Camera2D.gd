extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pos=get_parent().get_node("Particles2D").position
	position+=(pos-position)*delta*pos.distance_to(position)*0.6
	pass

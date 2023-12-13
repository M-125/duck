extends Particles2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	amount=1
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if amount<1/delta:
		amount=ceil(1/delta)
		
	var pos2=position
	var pos=get_parent().get_node("cursor").position
	if pos.distance_to(position)>20:
		
		position+=(pos-position).normalized()*30
	else:
		position=pos
	
	emitting=position!=pos2
	pass

extends Camera2D

var shake=0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("shake",self,"shake")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	shake=clamp(shake-30*delta,0,INF)
	position-=position*delta*10
	
	position=Vector2(rand_range(-1,1),rand_range(-1,1)).normalized()*shake
	pass

func shake(strength:float):
	shake=strength

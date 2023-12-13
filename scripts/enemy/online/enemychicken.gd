extends onlineenemy


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

func drop():
	for e in rand_range(0,50):
		placedrop(round(rand_range(0,3)))

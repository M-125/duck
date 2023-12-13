extends AnimatedSprite

var random=rand_range(200,800)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	set_process(false)
	yield(get_tree().create_timer(rand_range(0,0.7)),"timeout")
	animation="default"
	set_process(true)
	yield(get_tree().create_timer(10),"timeout")
	queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x+=random*delta
	pass

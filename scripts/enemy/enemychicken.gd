extends enemy

# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

func drop():
	for e in rand_range(0,50):
		var coin=drop.instance()
		coin.type=round(rand_range(0,3))
		get_parent().add_child(coin)
		coin.global_position=global_position

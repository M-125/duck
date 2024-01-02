extends enemy


func _ready():
	hp=1
	pass

func drop():
	var random=floor(rand_range(0,4))
	for e in range(8):
		placedrop(random)

func movement():
	return Vector2()

func damage(_e=1,_t=1,_r=1,_w=1):
	drop()
	Global.addsound("hit")
	queue_free()

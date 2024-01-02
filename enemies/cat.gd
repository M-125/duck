extends enemy
var move=0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func ready():
	hp=300
	pass 

func process(delta):
	move+=delta
	if move>0.5:
		move-=1
func movement():
	if move<0:
		return Vector2()
	var velocity=velTo(findplayer())*275*3
	velocity=pathfind_velocity(velocity)
	
	return velocity
func drop():
	for e in range(20):
		placedrop(small_thing.name2int("amethyst"))

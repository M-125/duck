extends enemy
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var savedveloc=Vector2()
var Attack=false
signal attack
var _cooldown=0
# Called when the node enters the scene tree for the first time.
func ready():
	connect("attack",self,"attack")
	hp=300
	pass 

func _process(delta):
	_cooldown-=delta

func movement():
	var velocity=velTo(findplayer())*DEFAULT_SPEED
	velocity=pathfind_velocity(velocity)
	if Attack:
		return savedveloc
	if findplayer().global_position.distance_to(global_position)<200 and _cooldown<0:
		savedveloc=velocity*3
		_cooldown=3
		emit_signal("attack")
	
	return velocity
func drop():
	for e in range(20):
		placedrop(small_thing.name2int("amethyst"))
func attack():
	Attack=true
	Attackdelay=0
	yield(get_tree().create_timer(0.4),"timeout")
	Attack=false
	Attackdelay=0.3

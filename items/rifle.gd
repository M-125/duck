extends Item
var usetime=-1
var interacting=false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	isgun=true
	damage=100
	cooldown=3.5
	chargetime=1.5
	pass # Replace with function body.

func process(delta):
	usetime-=delta
	if interacting:
		interacting=get_parent().name=="helditem"
	if usetime<=0 and interacting:
		queue_free()
		Global.player.hp+=15
	var rot=global_rotation_degrees
	while rot<0:
		rot=360-rot
	rot=fmod(rot,360)
	$Sprite.flip_v=rot<270 and rot>90
	

func reload():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func ability():
	pass

func use():
	
	return true


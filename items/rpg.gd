extends Item
var usetime=-1
var interacting=false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	isgun=true
	damage=20
	cooldown=2
	chargetime=1.5
	bullet=load("res://scenes/rocket.tscn")
	pass # Replace with function body.

func process(delta):
	$Sprite.frame=int(cldn<0)
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
	
	return false


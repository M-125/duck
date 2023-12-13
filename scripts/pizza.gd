extends Item
var usetime=-1
var interacting=false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	chargetime=1.5
	pass # Replace with function body.

func process(delta):
	usetime-=delta
	if interacting:
		interacting=get_parent().name=="helditem"
	if usetime<=0 and interacting:
		queue_free()
		Global.player.hp+=15
	

func reload():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func ability():
	var slices=round(rand_range(8,30))
	var rot=0
	var rounds=round(rand_range(1,3))
	for e in range(slices):
		var pizzaslice=preload("res://scenes/pizzaslice.tscn").instance()
		pizzaslice.velocity=Vector2(50,0).rotated(deg2rad(rot))
		Global.scene.add_child(pizzaslice)
		pizzaslice.global_position=global_position+Vector2(50,0).rotated(rot)
		
		rot+=360*rounds/slices
		if Server.isserver:
			Server.rpc("pizzaslice",pizzaslice.velocity,pizzaslice.global_position)
	
	queue_free()

func use():
	interacting=true
	usetime=2
	Global.alert("eating")
	return true
func cancel():
	interacting=false


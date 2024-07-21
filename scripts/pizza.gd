extends Item
var usetime=-1
var interacting=false
var count=1
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
		count-=1
		Global.player.hp+=15
		interacting=false
	if count<=0:
		queue_free()
	$Label.rect_rotation=-global_rotation_degrees
	$Label.text=str(count)+"x"
	

func reload():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func ability():
	var slices=round(rand_range(22,60))
	var rot=0
	var rounds=round(rand_range(1,floor(slices/20)))
	var damage=1000/slices
	
	for e in range(slices):
		var pizzaslice=preload("res://scenes/pizzaslice.tscn").instance()
		pizzaslice.velocity=Vector2(50,0).rotated(deg2rad(rot))
		Global.scene.add_child(pizzaslice)
		pizzaslice.global_position=global_position+Vector2(50,0).rotated(rot)
		pizzaslice.damage=damage
		rot+=360*rounds/slices
		if e %2==0:yield(get_tree(),"physics_frame")
	count-=1

func use():
	interacting=true
	usetime=2
	Global.alert("eating")
	return true
func cancel():
	interacting=false

func interact(player:Player):
	for e in player.items:
		var item=e.get_child(0)
		if item!=null and item.filename==filename:
			item.count+=1
			queue_free()
			return true
	return move_to_inventory(player)

extends Item
var interacting=false
var move=Vector2(0,0)
var ability=false
var process="idle"
var Enemy=null
var speed=0
var playersprite
var playercoll=0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	chargetime=1.5
	damage=20
	yield(get_tree(),"idle_frame")
	playersprite=Global.player.get_node("Sprite")
	pass # Replace with function body.

func process(delta):
	call(process,delta)

func idle(delta):
	if interacting:
		interacting=get_parent().name=="helditem"
	
	
func abilitymove(delta):
	if Enemy!=null and is_instance_valid(Enemy):
		var dist=Enemy.global_position.distance_squared_to(Global.player.global_position)
		if dist<30*30:
			
			process="idle"
			
			playersprite.rotation_degrees=0
			Global.player.collision_layer=playercoll
			Global.player.collision_mask=playercoll
			var dmgarea=preload("res://scenes/staticdmgarea.tscn").instance()
			
			Global.scene.add_child(dmgarea)
			dmgarea.global_position=global_position
		else:
			Global.player.global_position+=(Enemy.global_position-Global.player.global_position).normalized()*speed*delta*2
	else:
		process="idle"
		
		playersprite.rotation_degrees=0
		Global.player.collision_layer=playercoll
		Global.player.collision_mask=playercoll
			
	

func reload():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func ability():
	var dist=99999
	Enemy=null
	for e in Global.scene.get_children():
		if e is enemy:
			if e.global_position.distance_to(Global.player.global_position)<dist:
				dist=e.global_position.distance_to(Global.player.global_position)
				Enemy=e
		speed=clamp(dist,500,99999)
	
	playersprite.rotation_degrees=180
	process="abilitymove"
	playercoll=Global.player.collision_layer
	Global.player.collision_layer=0
	Global.player.collision_mask=0
	pass



func use():
	
	return false

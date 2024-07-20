extends Sprite
class_name small_thing
var sound="res://sounds/coin.tscn"
export(int,"coin","red dye","white dye","wood","amethyst") var type
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity=Vector2(rand_range(-30,30),rand_range(-30,30))

static func name2int(name):
	var names=["coin","red dye","white dye","wood","amethyst"]
	for e in range(names.size()): if name==names[e]:return e
func _ready():
	frame=type
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player=null
	
	if Server.isserver:
		rpc("pos",global_position)
	
	
	
	
	
	for e in get_parent().get_children():
		if "player" in e.name:
			if player!=null:
				if global_position.distance_to(e.global_position)<global_position.distance_to(player.global_position):
					player=e
			else:
				player=e
	if global_position.distance_to(player.global_position)>200:
		player=null
				
	if velocity<Vector2.ZERO:
		velocity-=velocity.normalized()*delta*60
		if velocity>Vector2.ZERO:
			velocity=Vector2.ZERO
		
		position+=velocity*delta*8
	if velocity>Vector2.ZERO:
		velocity-=velocity.normalized()*delta*60
		if velocity<Vector2.ZERO:
			velocity=Vector2.ZERO
		position+=velocity*delta*8
	if player !=null:
		if velocity==Vector2.ZERO:
			position-=(position-player.position).normalized()*400*delta
		if position.distance_to(player.position)<5:
			
			
			Global.small_stuff[type]+=1
			Global.addsound("coin")
			Quests.emit_signal("itemcollected",type)
			queue_free()

	pass


puppet func pos(p):
	global_position=p

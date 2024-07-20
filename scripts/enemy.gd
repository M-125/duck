extends KinematicBody2D
class_name enemy
var stun=0
export var hp=100
var veloc=Vector2.ZERO
var cooldown=0
var Cooldown=1
var dir=0
var resetdirdelay=0
var dircd=0.5
var deletecooldown=0
var dlc=false
var drop=load("res://scenes/coin.tscn")
var mustattack=10
var dropped=false
var attack=0
var attacking=false
var attackedplayer=null
var Attackdelay=0.2
export var Name="unnamed"
export var max_hp=0
export var flip_h=false
const DEFAULT_SPEED=300
signal attacked
var detected=[]
var forgettime=10
var Players=[]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemy")
	Global.connect("kill",self,"kill")
	if get_node_or_null('pathfind')!=null:
		$pathfind.collision_layer=4
		$pathfind.collision_mask=4
	if get_node_or_null('pathfind2')!=null:
		$pathfind2.collision_layer=4
		$pathfind2.collision_mask=4
	owner=get_parent()
	if get_node_or_null('collision')!=null:
		$collision.collision_layer=2
		$collision.collision_mask=2
	collision_mask=8
	collision_layer=8
	if not Server.serverspawned(self):name="enemy"+str(randi())
	if get_parent().get_node_or_null("MultiPlayerSpawner")!=null and not is_in_group("serverspawned"):
		get_parent().get_node_or_null("MultiPlayerSpawner").add_node(self)
	if get_node_or_null("damage")!=null:
		var node=$damage.duplicate(0)
		node.scale/=1.5
		add_child(node)
		node.name="near"
	ready()
	pass # Replace with function body.

func ready():
	
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if get_node_or_null("hpbar")!= null:
		if max_hp<hp:
			
			max_hp=hp
		$hpbar.max_value=max_hp
		$hpbar.value=hp
	mustattack-=delta
	resetdirdelay-=delta
	cooldown-=delta
	dircd-=delta
	deletecooldown-=delta
	attack-=delta
	for e in detected:
		e["time"]-=delta
		if e["time"]<0:
			detected.erase(e)
	if get_node_or_null("damage")!=null:
		attacking()
	if resetdirdelay<0:
		dir=0
	if stun<=0:
		move_and_slide(movement()*((int(mustattack>0)*2)+1))
	else:
		stun-=delta
		position+=(veloc/10)*delta
	process(delta)

func process(delta):
	pass

func placedrop(type):
	var coin=drop.instance()
	coin.type=type
	get_parent().add_child(coin)
	coin.global_position=global_position

func damage(dmg,velocity=Vector2(0,0),stunn=0.2):
	attacking=false
	Global.addsound("hit",global_position)
	var label=load("res://scenes/damagemeter.tscn").instance()
	label.get_node("Label").text=str(round(abs(dmg)))
	get_parent().add_child(label)
	label.global_position=global_position
	flash()
	if $MultiPlayerSyncer.is_master() or not Server.isconnect():
		
		veloc=velocity
		
		hp-=abs(dmg)
		stun=stunn
		
		if hp<=0:
			if not dropped:
				drop()
				death()
				dropped=true
			
			rpc("die")
			queue_free()
	else:rpc("askdmg",dmg,velocity,stunn)

	
	pass # Replace with function body.

func screenenter():
	mustattack=0
func drop():
	pass
func flash():
	modulate=Color("ffa382")
	yield(get_tree().create_timer(0.1),"timeout")
	modulate=Color("ffffff")
	yield(get_tree().create_timer(0.1),"timeout")
	modulate=Color("ffa382")
	yield(get_tree().create_timer(0.1),"timeout")
	modulate=Color("ffffff")
func pathfind_velocity(velocity):
	var realvel=velocity
	$pathfind.look_at(to_global(velocity))
	for collision in get_parent().get_children():
		if not collision==null and not "player" in collision.name:
			if $pathfind.overlaps_body(collision):
				if dir==0:
					dir=round(rand_range(-1,1))
				velocity=velocity.rotated(dir*deg2rad(90))
				$pathfind2.look_at(to_global(velocity))
				if $pathfind2.overlaps_body(collision)and dircd<0:
					dir*=-1
					dircd=2
				
				resetdirdelay=1
		if $pathfind/RayCast2D.get_collider()!=null:
			if "player" in $pathfind/RayCast2D.get_collider().name:
				dir=0
		
	if Global.gamefinished:
		velocity=-velocity
	if velocity.x>0:
		$Sprite.flip_h=flip_h
	elif velocity.x<0:
		$Sprite.flip_h=not flip_h
	
	if get_node_or_null("damage")!=null and findplayer() in $near.get_overlapping_bodies():
		velocity=Vector2.ZERO
	return velocity

func movement():
	$AnimationPlayer.play("walk")
	
		
	var player=findplayer()
		
	
	
	var velocity=Vector2.ZERO
	if player!=null:
		velocity=velTo(player)*DEFAULT_SPEED
		dlc=false
	else:
		if not dlc:
			dlc=true
			deletecooldown=60
		
		if player==null and dlc and deletecooldown<0:
			queue_free()
				
	
	var veloc2=Vector2(0,0)
	if velocity.x<0:
		veloc2.x=-7.5
	elif velocity.x>0:
		veloc2.x=7.5
	if velocity.y<0:
		veloc2.y=-7.5
	elif velocity.y>0:
		veloc2.y=7.5
	
		#*delta+veloc2*9
		
	velocity=pathfind_velocity(velocity)
	
	return velocity
		


func findplayer():
	var det=[]
	det.append_array(detected)
	var players=[]
	for i in get_parent().get_children():
		
		if i!=self and i.is_in_group("enemy") and i.position.distance_squared_to(position)<300000:
			det.append_array(i.detected)
			
		if i.is_in_group("player"):
			for e in det:
				if i==e["player"]:
					players.append(i)
			if i.position.distance_squared_to(position)<200000 and not Global.in_dict(i,detected,"player"):
				detected.append({"player":i,"time":forgettime})
		
		
	var minn=4000
	if mustattack>0:
		minn=INF
	var player=null
	
	Players=players
	for collision in players:
		if position.distance_to(collision.position)<minn:
			minn=position.distance_to(collision.position)
			player=collision
	if player==null:
		player=self
	return player
func velTo(player):
	return (player.position-position).normalized()

func distTo(player):
	return position.distance_to(player.position)
func attacking():
	for body in $damage.get_overlapping_bodies():
		if body.is_in_group("player") and cooldown<=0 and not attacking:
			attacking=true
			attack=Attackdelay
			attackedplayer=body
	if not attackedplayer in $damage.get_overlapping_bodies():
		attacking=false
	
	if attack<=0 and attacking:
		attackedplayer.dmg(5)
		emit_signal("attacked")
		cooldown=Cooldown
		attacking=false
	
func kill():
	while hp>0:
		yield(get_tree(),"idle_frame")
		damage(5)
remote func die():
	if not dropped:
			drop()
			dropped=true
	queue_free()

master func askdmg(dmg,velocity,stunn):
		
	veloc=velocity
	
	hp-=abs(dmg)
	stun=stunn
	flash()
	if hp<=0:
		if not dropped:
			drop()
			dropped=true
		rpc("die")
		queue_free()
func detect(r):
	for e in r:
	
		for i in detected:
			if e["player"]==i["player"]:
				
				break
		detected.append(e)


func death():
	Quests.emit_signal("enemykilled",Name)

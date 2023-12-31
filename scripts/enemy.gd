extends KinematicBody2D
class_name enemy
var stun=0
export var hp=100
var veloc=Vector2.ZERO
var cooldown=0
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
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_node_or_null('pathfind')!=null:
		$pathfind.collision_layer=4
		$pathfind.collision_mask=4
	if get_node_or_null('pathfind2')!=null:
		$pathfind2.collision_layer=4
		$pathfind2.collision_mask=4
	
	
	ready()
	pass # Replace with function body.

func ready():
	
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if get_node_or_null("hpbar")!= null:
		if $hpbar.max_value<hp:
			$hpbar.max_value=hp
		$hpbar.value=hp
	mustattack-=delta
	resetdirdelay-=delta
	cooldown-=delta
	dircd-=delta
	deletecooldown-=delta
	attack-=delta
	if get_node_or_null("damage")!=null:
		attacking()
	if resetdirdelay<0:
		dir=0
	if stun<=0:
		movement()
	else:
		stun-=delta
		move_and_slide(veloc/10)


func placedrop(type):
	var coin=drop.instance()
	coin.type=type
	get_parent().add_child(coin)
	coin.global_position=global_position

func damage(dmg,velocity=Vector2(0,0),stunn=0.2):
	attacking=false
	Global.addsound("hit",global_position)
	veloc=velocity
	var label=load("res://scenes/damagemeter.tscn").instance()
	label.get_node("Label").text=str(round(abs(dmg)))
	get_parent().add_child(label)
	label.global_position=global_position
	hp-=abs(dmg)
	stun=stunn
	flash()
	if hp<=0:
		if not dropped:
			drop()
			dropped=true
		queue_free()

	
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
func movement():
	$AnimationPlayer.play("walk")
	
		
	var player=findplayer()
		
	
	
	var velocity=Vector2.ZERO
	if player!=null:
		velocity=velTo(player)*275
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
		$Sprite.flip_h=false
	elif velocity.x<0:
		$Sprite.flip_h=true
	
	move_and_slide(velocity*(int(mustattack>0)*2+1))
		


func findplayer():
	
	var players=[]
	for i in get_parent().get_children():
		
		if "player" in i.name:
			players.append(i)
		
	var minn=4000
	if mustattack>0:
		minn=INF
	var player=null
	
	
	for collision in players:
		if position.distance_to(collision.position)<minn:
			minn=position.distance_to(collision.position)
			player=collision
	return player
func velTo(player):
	return (player.position-position).normalized()


func attacking():
	for body in $damage.get_overlapping_bodies():
		if "duckie" in body.name and cooldown<=0 and not attacking:
			attacking=true
			attack=0.3
			attackedplayer=body
	if not attackedplayer in $damage.get_overlapping_bodies():
		attacking=false
	
	if attack<=0 and attacking:
		attackedplayer.dmg(5)
		cooldown=1
		attacking=false
	

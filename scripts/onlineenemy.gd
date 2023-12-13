extends KinematicBody2D
class_name onlineenemy
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
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	mustattack-=delta
	resetdirdelay-=delta
	cooldown-=delta
	dircd-=delta
	deletecooldown-=delta
	if resetdirdelay<0:
		dir=0
	if stun<=0:
		var players=[]
		$AnimationPlayer.play("walk")
		for i in get_node("/root/map2").get_children():
			if "player" in i.name:
				players.append(i)
		
		var minn=4000
		if mustattack>0:
			minn=99999999
		var player=null
		
		
		for e in players:
			if position.distance_to(e.position)<minn:
				minn=position.distance_to(e.position)
				player=e
			
		
		
		var velocity=Vector2.ZERO
		if player!=null:
			velocity=(player.position-position).normalized()*275
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
		if $pathfind.overlaps_body(get_parent().get_node("trees")):
			if dir==0:
				dir=round(rand_range(-1,1))
			velocity=velocity.rotated(dir*deg2rad(90))
			$pathfind2.look_at(to_global(velocity))
			if $pathfind2.overlaps_body(get_parent().get_node("trees"))and dircd<0:
				dir*=-1
				dircd=2
			
			resetdirdelay=1
		if $pathfind/RayCast2D.get_collider()!=null:
			if $pathfind/RayCast2D.get_collider().name=="playerduckie":
				dir=0
		
		
		if velocity.x>0:
			$Sprite.flip_h=false
		elif velocity.x<0:
			$Sprite.flip_h=true
		move_and_slide(velocity*(int(mustattack>0)+1))
			
		pass
	else:
		stun-=delta
		move_and_slide(veloc/10)
	if Server.isserver:
		rpc_unreliable("animation",$AnimationPlayer.current_animation,$Sprite.flip_h)
		rpc_unreliable("updatepos",global_position)


func placedrop(type):
	Server.rpc("addcoin",global_position,type)

func damage(dmg,velocity=Vector2(0,0),stunn=0.2):
	rpc("Damage",dmg,velocity,stunn)
	

remotesync func Damage(dmg,velocity=Vector2(0,0),stunn=0.2):
	veloc=velocity
	var label=load("res://scenes/damagemeter.tscn").instance()
	label.get_node("Label").text=str(round(abs(dmg)))
	get_parent().add_child(label)
	label.global_position=global_position
	hp-=abs(dmg)
	stun=stunn
	modulate=Color("ffa382")
	yield(get_tree().create_timer(0.1),"timeout")
	modulate=Color("ffffff")
	yield(get_tree().create_timer(0.1),"timeout")
	modulate=Color("ffa382")
	yield(get_tree().create_timer(0.1),"timeout")
	modulate=Color("ffffff")
	if hp<=0:
		drop()
		queue_free()
	
func _on_Area2D_body_entered(body):
	if "player" in body.name and cooldown<=0:
		yield(get_tree().create_timer(0.3),"timeout")
		if body in $Area2D.get_overlapping_bodies() and cooldown<=0:
			
			body.rpc("dmg",5)
			cooldown=1
	pass # Replace with function body.
func Screenenter():
	rpc("screenenter")
remotesync func screenenter():
	mustattack=0
func drop():
	pass

puppet func updatepos(pos):
	global_position=pos

puppet func animation(anim,flip):
	var animplayer:AnimationPlayer=$AnimationPlayer
	animplayer.current_animation=anim
	$Sprite.flip_h=flip

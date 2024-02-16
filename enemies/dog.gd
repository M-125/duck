extends enemy
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var savedveloc=Vector2()
var Attack=false
signal attack
var _cooldown=0
var throwcooldown=0
var movewait=0
var bone=null
enum states{move,tobone,stop}
var state=0
# Called when the node enters the scene tree for the first time.
func ready():
	connect("attack",self,"attack")
	connect("attacked",self,"attacked")
	hp=50
	pass 

func process(delta):
	_cooldown-=delta
	throwcooldown-=delta
	for body in $throw.get_overlapping_bodies():
		if body is Player and throwcooldown<0:
			var bullet=load("res://enemies/dogbone.tscn").instance()
			Global.scene.add_child(bullet)
			bullet.global_position=global_position
			bullet.velocity=velTo(findplayer())
			bullet.speed=1000
			bone=bullet
			throwcooldown=3
			movewait=1
			$Timer.start()
			state=states.stop
	savedveloc-=savedveloc.normalized()*delta*1000
	
func movement():
	var velocity=Vector2()
	match state:
		states.move:
			velocity=velTo(findplayer())*DEFAULT_SPEED
			velocity=pathfind_velocity(velocity)
			if Attack or abs(savedveloc.x)>10 or abs(savedveloc.y)>10:
				position+=get_process_delta_time()*savedveloc
				return Vector2()
			if findplayer().global_position.distance_to(global_position)<200 and _cooldown<0:
				savedveloc=velocity*3
				_cooldown=3
				emit_signal("attack")
		states.tobone:
			if is_instance_valid(bone) :
				velocity=velTo(bone)*DEFAULT_SPEED*3
				if bone.position.distance_to(position)<10:
					bone.queue_free()
			else:
				state=states.move
			
		states.stop:
			velocity=Vector2()
	
	
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

func attacked():
	$Tween.interpolate_property(self,"savedveloc",-savedveloc*3,Vector2(0,0),0.7,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	$Tween.start()


func _on_Timer_timeout():
	state=states.tobone
	pass # Replace with function body.

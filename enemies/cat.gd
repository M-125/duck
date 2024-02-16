extends enemy
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var savedveloc=Vector2()
var Attack=false
signal attack
var _cooldown=0
var throwcooldown=0
# Called when the node enters the scene tree for the first time.
func ready():
	connect("attack",self,"attack")
	connect("attacked",self,"attacked")
	hp=50
	pass 

func _process(delta):
	_cooldown-=delta
	throwcooldown-=delta
	for body in $throw.get_overlapping_bodies():
		if body is Player and throwcooldown<0:
			var bullet=load("res://enemies/catshot.tscn").instance()
			Global.scene.add_child(bullet)
			bullet.global_position=global_position
			if body.global_position.y>global_position.y:
				$Tween.interpolate_property(bullet,"global_position:x",bullet.global_position.x,body.global_position.x+body.velocpredict.x*0.9,0.9,1,1)
				$Tween.interpolate_property(bullet,"global_position:y",bullet.global_position.y,body.global_position.y+body.velocpredict.y*0.9,0.9,Tween.TRANS_SINE,0)
			else:
				$Tween.interpolate_property(bullet,"global_position:y",bullet.global_position.y,body.global_position.y+body.velocpredict.y*0.9,0.9,1,1)
				$Tween.interpolate_property(bullet,"global_position:x",bullet.global_position.x,body.global_position.x+body.velocpredict.x*0.9,0.9,Tween.TRANS_SINE,0)
			$Tween.start()
			throwcooldown=3
	savedveloc-=savedveloc.normalized()*delta*1000
	
func movement():
	var velocity=velTo(findplayer())*DEFAULT_SPEED
	velocity=pathfind_velocity(velocity)
	if Attack or abs(savedveloc.x)>20 or abs(savedveloc.y)>20:
		position+=get_process_delta_time()*savedveloc
		return Vector2()
	if findplayer().global_position.distance_to(global_position)<200 and _cooldown<0:
		savedveloc=velocity*3
		_cooldown=3
		emit_signal("attack")
	
	
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

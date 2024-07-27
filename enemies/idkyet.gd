extends enemy
var Bullet=preload("res://enemies/gunshot.tscn")
var shootcooldown=0

func ready():
	hp=50

func process(delta):
	shootcooldown-=delta
	
	for body in $range.get_overlapping_bodies():
			if body is Player and shootcooldown<0:
				var bullet=Bullet.instance()
				Global.scene.add_child(bullet)
				bullet.global_position=global_position
				bullet.velocity=(velTo(findplayer())+((Vector2(rand_range(-10,10),rand_range(-10,10)).normalized())/5)).normalized()
				bullet.speed=650
				shootcooldown=1
			
func movement():
	var m=1
	if p_in_area($range):
		m=0.5
	if p_in_area($Near):
		m=0
	if p_in_area($back):
		m=-0.7
		shootcooldown=1
	return basic_movement()*m

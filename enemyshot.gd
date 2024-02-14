extends Area2D
class_name enemyprojectile
var velocity=Vector2()
var damage=3
var decay=1
var speed=100
var stun=0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_collision_layer_bit(0,true)
	set_collision_mask_bit(0,true)
	set_collision_layer_bit(1,true)
	set_collision_mask_bit(1,true)
	connect("body_entered",self,"_on_item_body_entered")
	setvalues()
	look_at(to_global(velocity*10))
	randomize()
	
	yield(get_tree().create_timer(decay),"timeout")
	queue_free()
	
	pass # Replace with function body.

func setvalues():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position+=velocity*delta*speed
#	$CollisionShape2D.shape.extents.x=delta*speed*10
	process(delta)
func process(delta):
	pass

func _on_item_body_entered(body):
	if body is Player:
		body.dmg(damage,velocity*100,stun)
		queue_free()
		
func damage(dmg=0,velocity=Vector2(0,0),stunn=0.2):
	Damage(velocity)
func Damage(vel):
	pass

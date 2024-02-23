extends Area2D
class_name projectile
var velocity
var damage=3
var decay=1
var speed=100
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	collision_layer=11
	collision_mask=11
	connect("body_entered",self,"_on_item_body_entered")
	setvalues()
	look_at(to_global(velocity*10))
	randomize()
	Global.player.get_node("hrot").rotation_degrees+=rand_range(-10,10)
	
	yield(get_tree().create_timer(decay),"timeout")
	queue_free()
	
	pass # Replace with function body.

func setvalues():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position+=velocity*delta*speed
	$CollisionShape2D.shape.extents.x=delta*speed*10
	process(delta)
func process(delta):
	pass

func _on_item_body_entered(body):
	if body is enemy:
		body.damage(damage,velocity*100,0.1)
		queue_free()

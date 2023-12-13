extends Sprite
var velocity=0
var timeup=false
var time=0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	delta*=2
	var scal=scale
	if scale.x<=0 and not timeup:
		velocity=0.5
	if timeup:
		if time<3:
			modulate.a8+=50*delta
		else:
			modulate.a8-=200*delta
		time+=delta
	velocity-=delta*0.5
	scale+=Vector2(velocity/5,velocity/5)*delta*60
#	pass


func _on_Timer_timeout():
	timeup=true
	pass # Replace with function body.

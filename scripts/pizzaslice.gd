extends projectile


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node e
func setvalues():
	damage=15
	decay=2
	velocity=velocity.normalized()*6
func _process(delta):
	position+=velocity*delta
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

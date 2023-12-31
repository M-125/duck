extends Area2D
class_name staticdmgarea
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _physics_process(delta):
	yield(get_tree(), "physics_frame")
	for body in get_overlapping_bodies():
		if body is enemy:
			body.damage(80,Vector2(rand_range(0,0.1),rand_range(0,0.1)).normalized()*8000,0.6)
	queue_free()

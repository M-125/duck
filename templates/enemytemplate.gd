extends enemy

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func ready():
	hp=300
	pass # Replace with function body.
#func flash():
#	$Sprite.material.set_shader_param("white",1)
#	yield(get_tree(),"idle_frame")
#	$Sprite.material.set_shader_param("white",0.75)
#	yield(get_tree(),"idle_frame")
#	$Sprite.material.set_shader_param("white",0.25)
#	yield(get_tree(),"idle_frame")
#	$Sprite.material.set_shader_param("white",0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func drop():
	for e in range(20):
		placedrop(small_thing.name2int("amethyst"))

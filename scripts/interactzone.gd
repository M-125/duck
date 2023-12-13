extends Area2D
class_name interact
export var press_e:NodePath=""
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _process(delta):
	if is_instance_valid(Global.player):
		if overlaps_body(Global.player):
			if not Global.player.is_connected("interact",self,"interact"):
				Global.player.connect("interact",self,"interact")
		else:
			if Global.player.is_connected("interact",self,"interact"):
				Global.player.disconnect("interact",self,"interact")
		if get_node_or_null(press_e)!=null:
			get_node(press_e).visible=overlaps_body(Global.player)
	process(delta)
func interact():
	pass
func process(delta):
	pass

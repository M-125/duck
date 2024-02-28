extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.player!=null and is_instance_valid(Global.player):
		global_position=Global.player.global_position
		material.set_shader_param("offset",global_position/3)
#	if Global.gamefinished:
#		set_process(false)
	pass

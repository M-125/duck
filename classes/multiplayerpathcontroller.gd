extends Node
class_name MultiPlayerPathController, "res://classes/spawner.png"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().connect("tree_exiting",self,"exit")
	get_parent().connect("tree_entered",self,"enter")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func exit():
	rpc("leavetree")
func enter():
	Server.rpc("entered",get_parent().name,get_parent().get_path())

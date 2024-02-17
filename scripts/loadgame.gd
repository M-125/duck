extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func new():
	get_tree().change_scene("res://scenes/map2.0.tscn")
	Global.savemap=null
	Global.playerpack=null
func Load():
	Global.savemap=load("user://save.tscn")
	Global.playerpack=load("user://saveplayer.tscn")
	Global.small_stuff=Saver.load("user://coins.json")
	get_tree().change_scene_to(Global.savemap)

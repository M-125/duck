extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if not ResourceLoader.exists("user://save.tscn"):
		new()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func new():
	get_tree().change_scene("res://scenes/map2.0.tscn")
	Global.savemap=null
	Global.playerpack=null
	Global.small_stuff=[0,0,0,0,0]
	var dir=Directory.new()
	for e in dir_contents("user://"):
		if "noise" in e:
			dir.remove(e)
	for e in dir_contents("user://"):
		if "house" in e:
			dir.remove(e)
func Load():
	Global.savemap=load("user://save.tscn")
	Global.playerpack=load("user://saveplayer.tscn")
	Global.small_stuff=Saver.load("user://coins.json")
	get_tree().change_scene_to(Global.savemap)

func dir_contents(path):
	var dir = Directory.new()
	var files=[]
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				files.append(path+file_name)
			file_name = dir.get_next()
	return files
																															

tool
extends Sprite
class_name Sprites
var textures=[]
export var Frame=0
export var folder="catrun"
export var files_in_folder=11
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	for e in range(files_in_folder):
		textures.append(load("res://"+folder+"/"+str(e+1)+".png"))
	texture=textures[0]
	pass # Replace with function body.


# Called every Frame. 'delta' is the elapsed time since the previous Frame.
func _process(delta):
	if Frame>=files_in_folder:
		Frame=files_in_folder-1
	elif Frame<0:
		Frame=0
	texture=textures[Frame]

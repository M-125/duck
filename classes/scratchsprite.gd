tool
extends Sprite
class_name Sprites
var textures={}
export var Frame=0
export var folder="catrun"
var prevar=""
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	prevar=folder
	var f=File.new()
	var i=0
	textures[folder]=[]
	while f.file_exists("res://"+folder+"/"+str(i+1)+".png"):
	
		textures[folder].append(load("res://"+folder+"/"+str(i+1)+".png"))
		i+=1

	texture=textures[folder][0]

	pass # Replace with function body.


# Called every Frame. 'delta' is the elapsed time since the previous Frame.
func _process(delta):
	if prevar!=folder or (not textures.has(folder)):_ready()
	if Frame>=textures[folder].size():
		Frame=textures[folder].size()-1
	elif Frame<0:
		Frame=0
	texture=textures[folder][Frame]
	
	

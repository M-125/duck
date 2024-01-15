extends Node
class_name MultiPlayerSyncer, "res://classes/syncer.png"
export var variables=["..:position"]
export var islocal=true
export var reliable=false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var list=[]
	for e in variables:
		list.append(NodePath(e))
	variables=list
	
	
	pass # Replace with function body.
func get_from_node(path:String):
	var array = path.split(":",false,2)
	var node=get_node(array[0])
	return node.get(array[1])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if islocal :
		for e in variables:
			if reliable:rpc("setvar",e,get_from_node(e))
			else: rpc_unreliable("setvar",e,e.get_from_node(e))
	pass
func set_from_node(path:String,val):
	var array = path.split(":",false,2)
	var node=get_node(array[0])
	node.set(array[1],val)

remote func setvar(path,value):
	set_from_node(path,value)

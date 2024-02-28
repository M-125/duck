extends Node
class_name MultiPlayerSyncer, "res://classes/syncer.png"
export var variables=["..:position"]
export var Master=false
export var reliable=false
export var all=false
export var refresh_rate=30
var timer=-0.3

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func islocal():
	var node=get_parent()
	var number=0
	while number==0 and node != get_tree().root:
		if int(node.name) in Server.clients:
			number=int(node.name)
		node=node.get_parent()
	return (not Master) and Server.ID==number
# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree(),"idle_frame")
	print(int(get_parent().name),get_parent().name)
	
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
	if is_inside_tree():
		timer+=delta
		if timer>1/refresh_rate and Server.isconnect():
			timer=0
			if islocal() or (Master and Server.isserver()):
				for e in variables:
					if reliable:rpc("setvar",e,get_from_node(e))
					else: rpc_unreliable("setvar",e,get_from_node(e))
	pass
func set_from_node(path:String,val):
	var array = path.split(":",false,2)
	var node=get_node(array[0])
	node.set(array[1],val)

remote func setvar(path,value):
	set_from_node(path,value)

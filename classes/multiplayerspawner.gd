extends Node
class_name MultiPlayerSpawner, "res://classes/spawner.png"
var nodes=[]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	while not Server.isconnect():yield(get_tree().create_timer(1),"timeout")
	rpc("get_spawned",Server.ID)
	pass # Replace with function body.

func _process(delta):
	for e in nodes:
		if not is_instance_valid(e):
			nodes.erase(e)
master func get_spawned(id):
	print(nodes)
	for e in nodes:
		if is_instance_valid(e):
			var node =e.filename
			rpc_id(id,"spawn",node,e.get_parent().get_path(),e.name)

remote func spawn(node,path,name):
	print(path,node,name)
	node=load(node)
	Global.alert(str(node)+"  "+path+"   "+name)
	for e in nodes:
		if str(path)+"/"+name ==e.get_path():
			return
	if get_node_or_null(path)!=null:
		var instance=node.instance()
		instance.name=name
		instance.add_to_group("serverspawned")
		get_node(path).add_child(instance)
		nodes.append(instance)

func add_node(node):
	while not Server.isconnect():yield(get_tree(),"idle_frame")
	for e in nodes:
		if not is_instance_valid(e):
			nodes.erase(e)
	for e in nodes:
		if (not is_instance_valid(e)) and node.get_path()==e.get_path():
			return
	if node in nodes:
		return
	nodes.append(node)
	rpc("spawn",node.filename,node.get_parent().get_path(),node.name)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

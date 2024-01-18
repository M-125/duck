extends Node

var map
var items=[]
var isserver=false
var players=[]
var ip
var server=null
var client=null
var playercount=0
var playerload=load("res://scenes/onlineplayer.tscn")
var clients=[]
var itemload=load("res://scenes/item.tscn")
var wait=0
var ID=0
var Seed=null
var trees=[0,0]
var chests=[0,0,0]
var tree=null
var chest=null
var counter=0
var outsideTreeList=[]
var connected=false
signal ID_received
signal connected
func _ready():
	
	for iip in IP.get_local_addresses():
		if iip.begins_with("192.168"):
			ip=iip
#	get_tree().connect("connected_to_server",self,"_connected_to_server")
	get_tree().connect("server_disconnected",self,"disconnected")
	get_tree().connect("network_peer_connected",self,"playerconnect")
	get_tree().connect("network_peer_disconnected",self,"playerdisconnect")
	get_tree().connect("connected_to_server",self,"connected")

func reset():
	 stop()
	 items=[]
	 isserver=false
	 players=[]
	 server=null
	 client=null
	 playercount=0
	 playerload=load("res://scenes/onlineplayer.tscn")
	 clients=[]
	 itemload=load("res://scenes/item.tscn")
	 wait=0
	 ID=0
	 
#func _connected_to_server():
#	pass

func disconnected():
	playercount=0
	print("disconnected")
	servershutdown()
	connected=false
	pass


func createserver():
	server=NetworkedMultiplayerENet.new()
	server.create_server(10281,10)
	get_tree().set_network_peer(server)
	isserver=true
	Seed=randi()
	ID=0
	print("server started")

func join(IP=ip):
	client=NetworkedMultiplayerENet.new()
	client.create_client(IP,10281)
	get_tree().set_network_peer(client)
	print(IP)

func playerconnect(id):
	if isserver:
		playercount+=1
		print("+++++++++++"+str(id))
		clients.append(id)
		
		rpc_id(id,"yourid",id)
		


func playerdisconnect(id):
	if isserver:
		print("--"+str(id))
		playercount-=1
		clients.erase(id)

		

	
func _process(delta):
	if isserver():
		ID=0

func connected():
	emit_signal("connected")
	connected=true
	print("connected")


func stop():
	rpc_id(0,"servershutdown")
	server.disconnect_peer(1)
	get_tree().set_network_peer(null)


remote func servershutdown():
	get_tree().change_scene("res://scenes/mainmenu.tscn")
	for p in players:
		if is_instance_valid(p):
			p.queue_free()
	players=[]
	


	



puppet func yourid(id):
	ID=id
	emit_signal("ID_received")

func isserver():
	return server!=null

func isconnect():
	if server!=null or connected:
		return true
	else:
		return false


	pass

remote func entered(name:String,path:String):
	print(name,path)
	for e in outsideTreeList:
		if name==e.name and get_node_or_null(path)!=null:
			get_node(path).add_child(e)
			outsideTreeList.erase(e)


remote func leavetree(path):
	print("leaving")
	var node=get_node_or_null(path)
	if node!=null:
		Server.outsideTreeList.append(node)
		
		node.get_parent().remove_child(node)

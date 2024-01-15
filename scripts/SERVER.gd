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
	servershutdown()
	pass


func createserver():
	server=NetworkedMultiplayerENet.new()
	server.create_server(10281,10)
	get_tree().set_network_peer(server)
	isserver=true
	Seed=randi()

func join():
	client=NetworkedMultiplayerENet.new()
	client.create_client(ip,10281)
	get_tree().set_network_peer(client)

func playerconnect(id):
	if isserver:
		playercount+=1
		print("+++++++++++"+str(id))
		rpc_id(id,"loadplayers",clients)
		clients.append(id)
		
		rpc_id(id,"yourid",id)
		rpc("addplayer",id)
		rpc("SeeD",Seed,trees[0],trees[1],chests[0],chests[1],chests[2])
		if not null in [tree,chest]:
			tree.update()
			chest.update()
		for e in clients+[0]:
			rpc_id(id,"addplayer",e)
		for e in Global.scene.get_children():
			if "enemy" in e.name:
				rpc_id(id,"addenemies",e.name,e.filename)
		


func playerdisconnect(id):
	if isserver:
		print("--"+str(id))
		playercount-=1
		clients.erase(id)
		rpc("removeplayer",id)

remotesync func removeplayer(id):
	for e in Global.scene.get_children():
		if e.name==str(id)+"player":
			e.queue_free()
			break
		
remotesync func addplayer(id):
	if ID!=id:
		var player=preload("res://scenes/onlineplayer.tscn").instance()
		player.name=str(id)+"player"
		player.get_node("ui").queue_free()
		Global.scene.add_child(player)
		player.position=Vector2(1,1)*-9000
	


func connected():
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
	


	



remote func yourid(id):
	ID=id
	Global.player.name=str(id)+"player"



func isconnect():
	if server!=null or client!=null:
		return true
	else:
		return false


	pass

remote func entered(name:String,path:String):
	for e in outsideTreeList:
		if name==e.name:
			path=path.trim_suffix(name)
			get_node(path).add_child(e)
			outsideTreeList.remove(e)

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


puppet func newitem(name,item,pos):
	var ITEM=preload("res://scenes/onlineitem.tscn").instance()
	ITEM.item=item
	ITEM.name=name
	Global.scene.add_child(ITEM)
	ITEM.global_position=pos
	print(name,item,pos)

puppet func uniqueitem(name,item,pos):
	var ITEM=load(item).instance()
	
	ITEM.name=name
	Global.scene.add_child(ITEM)
	ITEM.global_position=pos
	print(name,item,pos)

puppet func SeeD(sed,s1,rnd,s2,s3,rnd2):
	Seed=sed
	trees[0]=s1
	trees[1]=rnd
	chests[0]=s2
	chests[2]=rnd2
	chests[1]=s3


func _process(delta):
	if wait > 10 and isserver:
		rpc("SeeD",Seed,trees[0],trees[1],chests[0],chests[1],chests[2])
		wait=0
	wait +=delta


puppet func trees(s1,rnd):
	trees[0]=s1
	trees[1]=rnd

puppet func chests(s1,s2,rnd):
	
	chests[0]=s1
	chests[2]=rnd
	chests[1]=s2

puppet func addenemies(name,type):
	var Enemy=load(type).instance()
	Enemy.name=name
	Global.scene.add_child(Enemy)




remotesync func addcoin(pos,type=0):
	var coin=load("res://scenes/coin.tscn").instance()
	coin.name=str(counter)
	coin.type=type
	Global.scene.add_child(coin)
	
	coin.global_position=pos
	counter+=1


remote func pizzaslice(vel,pos):
	var p=preload("res://scenes/pizzaslice.tscn").instance()
	p.velocity=vel
	p.global_position=pos
	p.collision_layer=0
	p.collision_mask=0

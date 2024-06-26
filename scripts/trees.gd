extends TileMap

var positionn
var positionnn
var loadedchunks=[]
export var Seed=0
var rng=Rng.new()
export var random=0
var wait=0
onready var mainmap=get_parent().get_node("map")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	if random==0:random=randi()+randi()/randi()*randi()
	if Seed!=0:
		rng.Seed=Seed
	else:
		rng.randomize()
		Seed=rng.Seed
	loadpos0()
	rpc("askrandoms")
	Global.connect("reload",self,"reload")


func _process(delta):
	if wait>0.1 and Global.player!=null and is_instance_valid(Global.player):
		loadmap()
		erasemap()
		wait=0
	wait+=delta
func loadpos0():
	var pos=Vector2(0,0)
#	var viewdistance=Global.viewdistance*Global.chunksize
	var loaded=0
	for e in range(-2,3):
		for i in range(-2,3):
			var poss=Vector2(pos.x+e,pos.y+i)
			loaded+=loadchunk(poss)
	if loaded<=0:
		var view=Global.viewdistance/2
		var list=[]
		for e in range(pos.x-view,pos.x+view):
			for i in range(pos.y-view,pos.y+view):
				list.append(Vector2(e,i))
		var counter=0
		for e in list:
			if loadchunk(e)==1:
				counter+=1
#				if counter>=1:
				break
func loadmap():
	var pos=(world_to_map(to_local(Global.player.global_position))/Global.chunksize).round()
#	var viewdistance=Global.viewdistance*Global.chunksize
	var loaded=0
	for e in range(-2,3):
		for i in range(-2,3):
			var poss=Vector2(pos.x+e,pos.y+i)
			loaded+=loadchunk(poss)
	if loaded<=0:
		var view=Global.viewdistance/2
		var list=[]
		for e in range(pos.x-view,pos.x+view):
			for i in range(pos.y-view,pos.y+view):
				list.append(Vector2(e,i))
		var counter=0
		for e in list:
			if loadchunk(e)==1:
				counter+=1
#				if counter>=1:
				break

func loadchunk(pos):
	var mapedge=floor(world_to_map(to_local(mainmap.to_global(mainmap.map_to_world(Vector2(Global.mapsize-1,Global.mapsize-1))))).x-1)
	pos.x=clamp(pos.x,0,INF)
	pos.y=clamp(pos.y,0,INF)
	if not pos in loadedchunks:
		loadedchunks.append(pos)
		for e in range(clamp((pos.x)*(Global.chunksize),0,mapedge),clamp((pos.x+1)*(Global.chunksize),0,mapedge)):
			for i in range(clamp((pos.y)*(Global.chunksize),0,mapedge-1),clamp((pos.y+1)*(Global.chunksize),0,mapedge-1)):
				rng.state=int(str(e)+str(i))*random*(e%7)
				var rnd=rng.Randi_range(e,i,0,37)
				if round(rnd)==5 and not (
				get_cell(e,i+1)!=-1 or
				get_cell(e+1,i)!=-1 or
				get_cell(e,i-1)!=-1 or
				get_cell(e-1,i)!=-1
				):
					set_cell(e,i,rng.Randi_range(e,i,0,3))
		return 1
	return 0
			
			
		
	loadedchunks.append(pos)

func erasemap():
	var pos=(world_to_map(to_local(Global.player.global_position))/Global.chunksize).round()
	
	for a in loadedchunks:
		if abs(pos.x-a.x)>6 or abs(pos.y-a.y)>6:
			erasechunk(a)
			break

func erasechunk(pos):
	loadedchunks.erase(pos)
	for e in range(clamp((pos.x)*(Global.chunksize/1.5),0,Global.mapsize),clamp((pos.x+1)*(Global.chunksize/1.5),0,Global.mapsize)):
		for i in range(clamp((pos.y)*(Global.chunksize/1.5),0,Global.mapsize),clamp((pos.y+1)*(Global.chunksize/1.5),0,Global.mapsize)):
			set_cell(e,i,-1)
# Called every frame. 'delta' is the elapsed time since the previous frame.

puppet func random(s1,rnd):
	rng.Seed=s1
	Seed=s1
	random=rnd
	print("randoms",s1," ",rnd)
	Global.emit_signal("reload")

master func askrandoms():
	rpc("random",Seed,random)
	print("asked randoms")

func _on_Timer_timeout():
	rng.Seed=Seed
	pass # Replace with function body.
func reload():
	for e in loadedchunks:
		erasechunk(e)

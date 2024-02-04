extends TileMap

var positionn
var positionnn
var loadedchunks=[]
export var Seed=0
var rng=Rng.new()
export var random=0
var wait=0
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
		


func _process(delta):
	if wait>0.1:
		loadmap()
		erasemap()
		wait=0
	wait+=delta

func loadmap():
	var pos=(world_to_map(to_local(Global.playerposition))/Global.chunksize).round()
#	var viewdistance=Global.viewdistance*Global.chunksize
	var loaded=0
	for e in range(pos.x-Global.viewdistance/2,pos.x+Global.viewdistance/2):
		for i in range(pos.y-Global.viewdistance/2,pos.y+Global.viewdistance/2):
			var poss=Vector2(clamp(e,0,INF),clamp(i,0,INF))
			loaded+=loadchunk(Vector2(e,i))
	if loaded<=0:
		var list=[]
		for e in range(pos.x-Global.viewdistance,pos.x+Global.viewdistance):
			for i in range(pos.y-Global.viewdistance,pos.y+Global.viewdistance):
				list.append(Vector2(e,i))
		var counter=0
		for e in list:
			if loadchunk(e)==1:
				counter+=1
#				if counter>=1:
				break

func loadchunk(pos):
	var mapedge=world_to_map(get_parent().get_node("map").map_to_world(Vector2(Global.mapsize,Global.mapsize))).x-1
	if not pos in loadedchunks:
		loadedchunks.append(pos)
		for e in range(clamp((pos.x)*(Global.chunksize/1.5),0,mapedge),clamp((pos.x+1)*(Global.chunksize/1.5),0,mapedge)):
			for i in range(clamp((pos.y)*(Global.chunksize/1.5),0,mapedge),clamp((pos.y+1)*(Global.chunksize/1.5),0,mapedge)):
				rng.state=int(str(e)+str(i))*random*(e%7)
				var rnd=rng.Randi_range(e,i,0,37)
				print(rnd)
				if round(rnd)==5 and not (
				get_cell(e,i+1)==45 or
				get_cell(e+1,i)==45 or
				get_cell(e,i-1)==45 or
				get_cell(e-1,i)==45
				):
					set_cell(e,i,45)
		return 1
	return 0
			
			
		
	loadedchunks.append(pos)

func erasemap():
	var pos=(world_to_map(to_local(Global.playerposition))/Global.chunksize).round()
	
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
	random=rnd
	
func update():
	if Server.isserver:
		rpc("randoms",rng.Seed,random)


func _on_Timer_timeout():
	rng.Seed=Seed
	pass # Replace with function body.

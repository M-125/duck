extends TileMap

var positionn
var positionnn
var eraselist=[]
var rng=RandomNumberGenerator.new()
var rng2=RandomNumberGenerator.new()
var random
var openchests=[]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _process(delta):
	if Server.isserver:
		Server.chests=[rng.seed,rng2.seed,random]
	else:
		rng.seed=Server.chests[0]
		random=Server.chests[2]
		rng2.seed=Server.chests[1]
	erasemap()
	loadmap()
	
	
func loadmap(posi=null):
	
			
	var pos
	if posi==null:pos=(world_to_map(to_local(Global.playerposition))/(Global.chunksize)).round()
	else:pos=(world_to_map(to_local(posi))/(Global.chunksize)).round()
	if pos !=positionn:
		positionn=pos
		for e in range(clamp((pos.x-Global.viewdistance)*(Global.chunksize),0,Global.mapsize-2),clamp((pos.x+Global.viewdistance)*(Global.chunksize),0,Global.mapsize-2)):
			for i in range(clamp((pos.y-Global.viewdistance)*(Global.chunksize),0,Global.mapsize-2),clamp((pos.y+Global.viewdistance)*(Global.chunksize),0,Global.mapsize-2)):
				rng.state=int(str(e)+str(i))*random*(e%8)
				var rnd=rng.randi_range(0,1000)
				
				
				var opened=false
				for open in openchests:
					if open==Vector2(e,i):
						opened=true
				
				
				if round(rnd)==50 and !opened:
					set_cell(e,i,0)
				
				
			
		eraselist.append(pos)



func erasemap():
	var pos=(world_to_map(to_local(Global.playerposition))/(Global.chunksize)).round()
	if pos !=positionnn:
		positionnn=pos
		for a in eraselist:
			for e in range(clamp((a.x-Global.viewdistance)*(Global.chunksize),0,Global.mapsize),clamp((a.x+Global.viewdistance)*(Global.chunksize),0,Global.mapsize)):
				for i in range(clamp((a.y-Global.viewdistance)*(Global.chunksize),0,Global.mapsize),clamp((a.y+Global.viewdistance)*(Global.chunksize),0,Global.mapsize)):
					set_cell(e,i,-1)
		eraselist=[]
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	Server.chest=self
	rng2.randomize()
	random=(rng2.randi()+rng2.randi()/rng2.randi()*rng2.randi()-rng2.randi())*rng2.state


remotesync func appen(tilepos):
	openchests.append(tilepos)
	set_cellv(tilepos,-1)
	loadmap()

extends TileMap

var positionn
var positionnn
var eraselist=[]
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
		rng.seed=Seed
	else:
		rng.randomize()
		Seed=rng.seed
		


func _process(delta):
	if Server.isserver:
		wait-=delta
		if wait<=0:
			rpc("randoms",rng.seed,random)
			wait=20
	erasemap()
	loadmap()
func loadmap():
	
			
			
	var pos=(world_to_map(to_local(Global.playerposition))/(Global.chunksize/1.5)).round()
	if pos !=positionn:
		positionn=pos
		for e in range(clamp((pos.x-Global.viewdistance)*(Global.chunksize/1.5),0,Global.mapsize-2),clamp((pos.x+Global.viewdistance)*(Global.chunksize/1.5),0,Global.mapsize-2)):
			for i in range(clamp((pos.y-Global.viewdistance)*(Global.chunksize/1.5),0,Global.mapsize-2),clamp((pos.y+Global.viewdistance)*(Global.chunksize/1.5),0,Global.mapsize-2)):
				rng.state=int(str(e)+str(i))*random*(e%8)
				var rnd=rng.Randi_range(e,i,0,20)
				if round(rnd)==5 and not (
				get_cell(e,i+1)==45 or
				get_cell(e+1,i)==45 or
				get_cell(e,i-1)==45 or
				get_cell(e-1,i)==45
				):
					set_cell(e,i,45)
				
				
			
		eraselist.append(pos)



func erasemap():
	var pos=(world_to_map(to_local(Global.playerposition))/(Global.chunksize/1.5)).round()
	if pos !=positionnn:
		positionnn=pos
		for a in eraselist:
			for e in range(clamp((a.x-Global.viewdistance)*(Global.chunksize/1.5),0,Global.mapsize),clamp((a.x+Global.viewdistance)*(Global.chunksize/1.5),0,Global.mapsize)):
				for i in range(clamp((a.y-Global.viewdistance)*(Global.chunksize/1.5),0,Global.mapsize),clamp((a.y+Global.viewdistance)*(Global.chunksize/1.5),0,Global.mapsize)):
					set_cell(e,i,-1)
		eraselist=[]
# Called every frame. 'delta' is the elapsed time since the previous frame.

puppet func random(s1,rnd):
	rng.seed=s1
	random=rnd
	
func update():
	if Server.isserver:
		rpc("randoms",rng.seed,random)

extends TileMap

var positionn
var positionnn
var eraselist=[]
var rng=RandomNumberGenerator.new()
export var random=0
var wait=0
export var rngseed=0
var dontspawn=[]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"



func _process(delta):
	
	if rngseed==0:rngseed=rng.seed
	else:rng.seed=rngseed
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
				var rnd=rng.randi_range(0,20)
				
				
				if round(rnd)==5 :
					set_cell(e,i,0)
					var map=Global.map1
					
					var startpos=to_global(map_to_world(Vector2(e,i)))
					var endpos=to_global(map_to_world(Vector2(e+1,i+1)))
					var startpos2=map.world_to_map(map.to_local(startpos))
					var endpos2=map.world_to_map(map.to_local(endpos))-Vector2(1,1)
					get_parent().get_node("loader").noise.addzone(Rect2(startpos2,endpos2-startpos2),"<1")
					
					get_parent().get_node("loader").noise.addzone(Rect2(startpos2-Vector2(5,5),endpos2-startpos2+Vector2(10,10)),"<2")
					get_parent().get_node("loader").noise.addzone(Rect2(startpos2-Vector2(10,10),endpos2-startpos2+Vector2(20,20)),"<3")
					var map2=get_parent().get_node("trees")
					var startpos3=map2.world_to_map(map2.to_local(startpos))
					var endpos3=map2.world_to_map(map2.to_local(endpos))-Vector2(1,1)
					map2.rng.addzone(Rect2(startpos3,endpos3-startpos3))
				
				
			
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

puppet func randoms(s1,rnd):
	rng.seed=s1
	random=rnd
	
func update():
	if Server.isserver:
		rpc("randoms",rng.seed,random)

func _ready():
	if random==0:
		random=randi()+randi()/randi()*randi()


func _on_Timer_timeout():
	rng.seed=rngseed
	pass # Replace with function body.

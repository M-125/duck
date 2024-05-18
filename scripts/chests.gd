extends TileMap

var positionn
var positionnn
var eraselist=[]
var rng=RandomNumberGenerator.new()
var rng2=RandomNumberGenerator.new()
export var random=0
var openchests=[]
export var Seed=0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func loadmap():
	
			
			
	var pos=(world_to_map(to_local(Global.playerposition))/(Global.chunksize)).round()
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
				yield(get_tree(),"idle_frame")
				
				
			
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
	if Seed!=0:
		rng.seed=Seed
	else:
		rng.randomize()
		Seed=rng.seed
	if random==0:
		random=(rng2.randi()+rng2.randi()/rng2.randi()*rng2.randi()-rng2.randi())*rng2.state
	rpc("askrandoms")
	Global.connect("reload",self,"reload")

func _on_Timer_timeout():
	rng.seed=Seed
	pass # Replace with function body.


func loadstuff():
	erasemap()
	loadmap()


puppet func random(s1,rnd):
	rng.seed=s1
	Seed=s1
	random=rnd

master func askrandoms():
	rpc("random",Seed,random)

func reload():
	positionn=Vector2(-200,-200)
	positionnn=Vector2(-200,-200)
func loot(tilepos):
	if get_cellv(tilepos)==0:
		return Global.itemloot[floor(rand_range(0,len(Global.itemloot)))]

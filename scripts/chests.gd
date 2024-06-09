extends TileMap

var positionn
var positionnn
var eraselist=[]
var rng=Rng.new()
var rng2=RandomNumberGenerator.new()
var chestviewdistance=2
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
		print("bruh",clamp((pos.x-chestviewdistance)*(Global.chunksize),0,Global.mapsize-2),"b2",clamp((pos.x+chestviewdistance)*(Global.chunksize),0,Global.mapsize-2))
		for e in range(clamp((pos.x-chestviewdistance)*(Global.chunksize),0,Global.mapsize-2),clamp((pos.x+chestviewdistance)*(Global.chunksize),0,Global.mapsize-2)):
			for i in range(clamp((pos.y-chestviewdistance)*(Global.chunksize),0,Global.mapsize-2),clamp((pos.y+chestviewdistance)*(Global.chunksize),0,Global.mapsize-2)):
				rng.state=int(str(e)+str(i))*random*(e%8)
				var rnd=rng.randi_range(0,501)
				
				
				var opened=false
				for open in openchests:
					if open==Vector2(e,i):
						opened=true
				
				
				if round(rnd)==25 and !opened:
					set_cell(e,i,0)
			yield(get_tree(),"idle_frame")
				
				
			
		eraselist.append(pos)



func erasemap():
	var pos=(world_to_map(to_local(Global.playerposition))/(Global.chunksize)).round()
	if pos !=positionnn:
		positionnn=pos
		for a in eraselist:
			if abs(pos.x-a.x)>chestviewdistance or abs(pos.y-a.y)>chestviewdistance:
				for e in range(clamp((a.x-chestviewdistance)*(Global.chunksize),0,Global.mapsize),clamp((a.x+chestviewdistance)*(Global.chunksize),0,Global.mapsize)):
					for i in range(clamp((a.y-chestviewdistance)*(Global.chunksize),0,Global.mapsize),clamp((a.y+chestviewdistance)*(Global.chunksize),0,Global.mapsize)):
						set_cell(e,i,-1)
				eraselist.erase(a)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	if Seed!=0:
		rng.seed=Seed
	else:
		rng.randomize()
		Seed=rng.Seed
	if random==0:
		random=(rng2.randi()+rng2.randi()/rng2.randi()*rng2.randi()-rng2.randi())*rng2.state
	rpc("askrandoms")
	Global.connect("reload",self,"reload")

func _on_Timer_timeout():
	rng.Seed=Seed
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

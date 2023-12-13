extends Node2D

var positionn
var positionnn
var eraselist=[]
var rng=RandomNumberGenerator.new()
var rng2=RandomNumberGenerator.new()
var random
var spawned=[]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _process(delta):
	loadmap()
func loadmap():
	if Global.nochick:
		return
			
			
	var pos=(to_local(Global.playerposition)/16/3/(Global.chunksize)).round()
	if pos !=positionn:
		positionn=pos
		var viewdist=2
		for e in range(clamp((pos.x-viewdist)*(Global.chunksize),0,Global.mapsize-2),clamp((pos.x+viewdist)*(Global.chunksize),0,Global.mapsize-2)):
			for i in range(clamp((pos.y-viewdist)*(Global.chunksize),0,Global.mapsize-2),clamp((pos.y+viewdist)*(Global.chunksize),0,Global.mapsize-2)):
				rng.state=int(str(e)+str(i))*random*(e%8)
				var rnd=rng.randi_range(0,1000)
				
				
				var spawnn=false
				for spawn in spawned:
					if spawn==Vector2(e,i):
						spawnn=true
				
				
				if round(rnd)==200 and !spawnn:
					rpc("spawn",e,i)
					spawned.append(Vector2(e,i))
				
				
			

remotesync func Place(chick,x,y,name):
	var ourchick=load(chick).instance() 
	ourchick.name="enemy"+str(Vector2(x,y))+str(name)
	get_node("/root/map2").add_child(ourchick)
	ourchick.global_position=to_global(Vector2(x,y)*16)
	ourchick.global_position+=Vector2(rand_range(-32,32),rand_range(-32,32))
	
func place(path,x,y):
	rpc("Place",path,x,y,round(rand_range(0,10000)))
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	
	rng2.randomize()
	random=(rng2.randi()+rng2.randi()/rng2.randi()*rng2.randi()-rng2.randi())*rng2.state

master func spawn(x,y):
	var spwn=false
	var random=round(rand_range(0,2))
	while !spwn:
		if random==0 or random==2:
			spwn=true
			var chicken="res://scenes/online/enemychicken.tscn"
			for i in range(rand_range(2,5)):
				place(chicken,x,y)
		elif random==1:
				spwn=true
				place("res://scenes/online/enemy.tscn",x,y)

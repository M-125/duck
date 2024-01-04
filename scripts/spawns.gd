extends Node2D

var positionn
var positionnn
var eraselist=[]
var rng=RandomNumberGenerator.new()
var rng2=RandomNumberGenerator.new()
var random
var spawned=[]
var spawnwait=10
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _process(delta):
	loadmap()
	if Global.endgame and spawnwait<=0:
		var spwn=false
		while !spwn:
			var rnd=round(rand_range(0,3))
			var vector=Vector2(rand_range(-1,1),rand_range(-1,1)).normalized()*1500
			if rnd==0 or rnd==2:
				spwn=true
				var chicken=preload("res://scenes/enemychicken.tscn")
				
				place(chicken.instance(),
				Global.player.global_position.x+vector.x,
				Global.player.global_position.y+vector.y,false)
			elif rnd==1:
				spwn=true
				var chicken=preload("res://scenes/enemy.tscn")
				place(chicken.instance(),
				Global.player.global_position.x+vector.x,
				Global.player.global_position.y+vector.y,false)
		spawnwait=0.5
	spawnwait-=delta
func loadmap():
	if Global.nochick or spawnwait>=0:
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
					spawn(e,i)
					spawned.append(Vector2(e,i))
				
				
			

func place(chick,x,y,gridsnap=true):
	get_node("/root/map2").add_child(chick)
	if gridsnap:chick.global_position=to_global(Vector2(x,y)*16)
	else:chick.global_position=to_global(Vector2(x,y))
	chick.global_position+=Vector2(rand_range(-32,32),rand_range(-32,32))


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	print(spawnwait)
	rng2.randomize()
	random=(rng2.randi()+rng2.randi()/rng2.randi()*rng2.randi()-rng2.randi())*rng2.state

func spawn(x,y):
	print(spawnwait)
	var spwn=false
	var random=round(rand_range(0,2))
	while !spwn:
		if random==0 or random==2:
			spwn=true
			var chicken=preload("res://scenes/enemychicken.tscn")
			for i in range(rand_range(2,5)):
				place(chicken.instance(),x,y)
#				place(preload("res://scenes/enemy.tscn").instance(),x,y)
		elif random==1:
				spwn=true
				place(preload("res://scenes/enemy.tscn").instance(),x,y)

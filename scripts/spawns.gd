extends Node2D

var positionn
var positionnn
var eraselist=[]
var rng=RandomNumberGenerator.new()
var rng2=RandomNumberGenerator.new()
var random
export var spawnwait=30
var enemies={
	"dog":load("res://enemies/dog.tscn")
}
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _process(delta):
	loadmap()
	spawnwait-=delta
	
func loadmap():
	if not( Global.nochick or spawnwait>=0):
		
			
	
		var pos=(to_local(Global.playerposition)/16/3/(Global.chunksize)).round()
		if pos !=positionn:
			positionn=pos
			var viewdist=2
			for e in range(clamp((pos.x-viewdist)*(Global.chunksize),0,Global.mapsize-2),clamp((pos.x+viewdist)*(Global.chunksize),0,Global.mapsize-2)):
				for i in range(clamp((pos.y-viewdist)*(Global.chunksize),0,Global.mapsize-2),clamp((pos.y+viewdist)*(Global.chunksize),0,Global.mapsize-2)):
					rng.state=int(str(e)+str(i))*random*(e%8)
					var rnd=rng.randi_range(0,1000)
					
					
					
					
					if round(rnd)==200:
						
						spawnwait=spawn(e,i)
						print(spawnwait)
					
				
			

func place(chick,x,y,gridsnap=true):
	get_node("/root/map2").add_child(chick)
	if gridsnap:chick.global_position=to_global(Vector2(x,y)*16*3*Global.chunksize)
	else:chick.global_position=to_global(Vector2(x,y))
	chick.global_position+=Vector2(rand_range(-32,32),rand_range(-32,32))


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	if Server.client!=null:queue_free()
	rng2.randomize()
	random=(rng2.randi()+rng2.randi()/rng2.randi()*rng2.randi()-rng2.randi())*rng2.state

func spawn(x,y):
	var spwn=int(round(rand_range(1,5)))
	var spawnwait=spwn*20
	var random=int(round(rand_range(0,4)))
	while spwn >0:
		match random:
			0,3:
				spwn-=1
				var chicken=preload("res://scenes/enemychicken.tscn")
				for i in range(rand_range(1,2)):
					place(chicken.instance(),x,y)
#				place(preload("res://scenes/enemy.tscn").instance(),x,y)
			1:
				spwn-=1
				place(preload("res://scenes/enemy.tscn").instance(),x,y)
			2:
				spwn-=1
				place(preload("res://enemies/cat.tscn").instance(),x,y)
			4:
				spwn-=1
				place(enemies["dog"].instance(),x,y)
		random=int(round(rand_range(0,4)))
		
	return spawnwait

extends Node2D
class_name enspw
var positionn
var positionnn
var noload=[]
var rng=Rng.new()
var rng2=RandomNumberGenerator.new()
var random
export var spawnwait=15
var enemies={
	"dog":load("res://enemies/dog.tscn")
}
var chunk=[]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _process(delta):
	loadmap()
	spawnwait-=delta
	for e in chunk:
		e["time"]-=delta
		if e["time"]<=0:
			chunk.erase(e)
	var enemies=[]
	for e in get_parent().get_children():
		if e.is_in_group("enemy"):
			enemies.append(e)
	if enemies.size()>6:
		enemies.sort_custom(self,"sort")
		for e in range(enemies.size()-1,20,-1):
			enemies[e].queue_free()
			
	
func loadmap():
	if not( Global.nochick or spawnwait>=0):
		
			
	
		var pos=(to_local(Global.playerposition)/16/3/(Global.chunksize)).round()
		
		var viewdist=0.5
		for e in range(clamp((pos.x-viewdist)*(Global.chunksize),0,Global.mapsize-2),clamp((pos.x+viewdist)*(Global.chunksize),0,Global.mapsize-2),Global.chunksize/2):
			var canbreak=false
			for i in range(clamp((pos.y-viewdist)*(Global.chunksize),0,Global.mapsize-2),clamp((pos.y+viewdist)*(Global.chunksize),0,Global.mapsize-2),Global.chunksize/2):
				
				
				if not Vector2(e,i)in noload:
					rng.state=(1+int(str(e)+str(i)))*random+1*(e%8)+1
					var rnd=rng.randi_range(1,4)
					
					
					
					if round(rnd)==2:
						
						spawn(e,i)
						spawnwait=0.1
						canbreak=true
						break
					else:
						noload.append(Vector2(e,i))
			if canbreak:break
			

func place(chick,x,y,gridsnap=true):
	get_node("/root/map2").add_child(chick)
	if gridsnap:chick.global_position=to_global(Vector2(x,y)*16*3)
	else:chick.global_position=to_global(Vector2(x,y))
	chick.global_position+=Vector2(rand_range(-64,64),rand_range(-64,64))


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	Global.connect("horde",self,"horde")
	if Server.client!=null:queue_free()
	rng2.randomize()
	random=(rng2.randi()+rng2.randi()/rng2.randi()*rng2.randi()-rng2.randi())*rng2.state

func spawn(x,y):
	for e in chunk:
		if e["pos"]==Vector2(x,y):
			return
	var spwn=int(round(rand_range(3,5)))
	var spawnwait=spwn*20
	var random=int(round(rand_range(0,10)))
	while spwn >0:
		match random:
			0,3,4,5,6,9,10:
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
			7:
				spwn-=1
				place(preload("res://enemies/dog.tscn").instance(),x,y)
			8:
				spwn-=1
				place(preload("res://enemies/idkyet.tscn").instance(),x,y)
		random=int(round(rand_range(0,4)))
		
	chunk.append({"pos":Vector2(x,y),"time":spawnwait})
func horde():
	var pos=(to_local(Global.playerposition)/16/3/(Global.chunksize)).round()
	spawn(pos.x,pos.y)

func sort(a,b):
	if a==null:return false
	if b==null:return true
	if (Global.player==null and a.position.x>b.position.x):return true
	if a.position.distance_to(Global.player.position)<b.position.distance_to(Global.player.position) :
		return true
	return false

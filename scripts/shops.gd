extends Node2D
onready var mainmap=get_parent().get_node("map")
var positionn
var positionnn
var shops=[]
var rng=Rng.new()
var rng2=RandomNumberGenerator.new()
var noshop=[]
export var random:float=0
export var Seed:float=0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _process(delta):
	loadmap()
func loadmap():
	for e in shops:
		if not is_instance_valid(e):
			shops.erase(e)
			
	var pos=(to_local(Global.playerposition)).round()
	var mapedge=to_local(mainmap.to_global(mainmap.map_to_world(Vector2(Global.mapsize,Global.mapsize))))
	pos.x=clamp(pos.x,0,floor(mapedge.x))
	pos.y=clamp(pos.y,0,floor(mapedge.y))
	for x in range(-5,6):
		for y in range(-5,6):
			loadpos(pos+Vector2(x,y))
				
	for e in noshop:
		if abs(pos.x-e.x)>10 or abs(pos.y-e.y)>10:
			noshop.erase(e)
			

func loadpos(pos):
	if pos in noshop:
		return
	rng.state=fmod((pos.y)*(pos.x)*random,65535)
	
	var rnd=rng.randi_range(0,100)
	
#			Global.debug.text=str((pos.x+x)*217+(pos.y+y)*16*random)+"---"+str(rng.state)+"++++"+str(rng.seed)
	if rnd==1:
		var canspawn=true
		for e in shops:
			if is_instance_valid(e) and e.pos==pos:
				return
		var shop=load("res://scenes/shop.tscn").instance()
		get_parent().add_child(shop)
		shop.global_position=to_global(pos)
		shop.pos=pos
		shop.name=str(pos)+"shop"
		shops.append(shop)
	else:
		noshop.append(pos)

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	if Server.client!=null:queue_free()
	if random==0:
		rng2.randomize()
		random=round((rng2.randi()))
		rng.randomize()
		
		Seed=rng.Seed
	rng.Seed=Seed


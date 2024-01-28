extends Node2D

var positionn
var positionnn
var shops=[]
var rng=Rng.new()
var rng2=RandomNumberGenerator.new()
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
	
	pos.x=clamp(pos.x,0,INF)
	pos.y=clamp(pos.y,0,INF)
	for x in range(-10,11):
		for y in range(-10,11):
			loadpos(pos+Vector2(x,y))
				
				
			

func loadpos(pos):
	rng.state=fmod((pos.y)*(pos.x)*random,65535)
	
	var rnd=rng.randi_range(0,1000)
	Global.debug.text=str(rnd)
#			Global.debug.text=str((pos.x+x)*217+(pos.y+y)*16*random)+"---"+str(rng.state)+"++++"+str(rng.seed)
	if rnd==1:
		var canspawn=true
		for e in shops:
			if is_instance_valid(e) and e.pos==pos:
				canspawn=false
		if canspawn:
			var shop=load("res://scenes/shop.tscn").instance()
			get_parent().add_child(shop)
			shop.global_position=to_global(pos)
			shop.pos=pos
			shop.name=str(pos)+"shop"
			shops.append(shop)

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	if Server.client!=null:queue_free()
	if random==0:
		rng2.randomize()
		random=round((rng2.randi()))
		rng.randomize()
		
		Seed=rng.Seed
	rng.Seed=Seed


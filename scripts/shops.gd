extends Node2D

var positionn
var positionnn
var shops=[]
var rng=RandomNumberGenerator.new()
var rng2=RandomNumberGenerator.new()
var random
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _process(delta):
	loadmap()
func loadmap():
	for e in shops:
		if not is_instance_valid(e):
			shops.erase(e)
			
	var pos=(to_local(Global.playerposition)/16/3/16).round()
	if pos !=positionn:
		positionn=pos
		for x in range(-1,2):
			for y in range(-1,2):
				
				rng.state=int(str((pos.x+x)*16)+str((pos.y+y)*16))*random*(int(pos.x+x) %8)
				var rnd=rng.randi_range(0,10)
			
				if round(rnd)==1:
					var canspawn=true
					var pos1=pos+Vector2(x,y)
					for e in shops:
						if e.pos==pos1:
							canspawn=false
					if canspawn:
						var shop=load("res://scenes/shop.tscn").instance()
						get_parent().add_child(shop)
						shop.global_position=to_global(pos1*16*3*16)
						shop.pos=pos1
						shop.name=str(pos1)+"shop"
						shops.append(shop)
				
				
			



# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	
	rng2.randomize()
	random=(rng2.randi()+rng2.randi()/rng2.randi()*rng2.randi()-rng2.randi())*rng2.state



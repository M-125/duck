extends TileMap
var list=[]
var map=[]
var mapfloor=1
onready var floor2=get_parent().get_node("map2")
onready var floor3=get_parent().get_node("map3")
var badlist=[-1,47,17,20,18,48,50,49]
var finalmap=[]
var eraselist=[]
var noise=OpenSimplexNoise.new()
var positionn=Vector2(0,0)
var positionnn=Vector2(0,0)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var terrain={
	"left":6,
	"leftup":0,
	"rightup":2,
	"up":1,
	"leftdown":48,
	"rightdown":50,
	"right":14,
	"down":49,
	"rightleft":11,
	"rightleftdown":58,
	"rightleftup":5,
	"leftdownup":54,
	"rightdownup":56,
	"downup":55
	,"rightleftdownup":-1
}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	randomize()
#	while Server.Seed==null:pass
	
	Global.playerfloor=4
	Global.map1=self
	Global.map2=floor2
	Global.map3=floor3
	floor2.myfloor=2
	floor3.myfloor=3
	floor2.noise=noise
	floor3.noise=noise
	yield(get_tree().create_timer(1),"timeout")
#	var packed_scene = PackedScene.new()
#	packed_scene.pack(get_tree().get_current_scene())
#	ResourceSaver.save("res://my_scene.tscn", packed_scene)
	

func _process(delta):
	if Server.Seed!=null:
		noise.seed=Server.Seed
	floor2.noise=noise
	floor3.noise=noise
	if Global.playerfloor>=mapfloor:
		set_collision_layer_bit(0,false)
		set_collision_mask_bit(0,false)
	else:
		set_collision_layer_bit(0,true)
		set_collision_mask_bit(0,true)
	erasemap()
	loadmap()
	



func loadmap():
	
			
			
	var pos=(world_to_map(to_local(Global.playerposition))/Global.chunksize).floor()
	if pos !=positionn:
		positionn=pos
		for e in range(clamp((pos.x-Global.viewdistance)*Global.chunksize,0,Global.mapsize),clamp((pos.x+Global.viewdistance)*Global.chunksize,0,Global.mapsize)):
			for i in range(clamp((pos.y-Global.viewdistance)*Global.chunksize,0,Global.mapsize),clamp((pos.y+Global.viewdistance)*Global.chunksize,0,Global.mapsize)):
				
				var noiser=abs(noise.get_noise_2d(e,i))*10
				
				if noiser>1 :
					var side=""
					if (abs(noise.get_noise_2d(e+1,i)))*10<1 or e==Global.mapsize-1 :
						side+="right"
					if (abs(noise.get_noise_2d(e-1,i)))*10<1 or e==0 :
						side+="left"
					if (abs(noise.get_noise_2d(e,i+1)))*10<1 or i==Global.mapsize-1 :
						side+="down"
					if (abs(noise.get_noise_2d(e,i-1)))*10<1 or i==0  :
						side+="up"
				
					if side!="":
						set_cell(e,i,terrain[side])
					else:
						set_cell(e,i,7)
				else:
					set_cell(e,i,-1)
				
			
		eraselist.append(pos)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
##	pass
func erasemap():
	var pos=(world_to_map(to_local(Global.playerposition))/Global.chunksize).floor()
	if pos !=positionnn:
		positionnn=pos
		for a in eraselist:
			for e in range(clamp((a.x-Global.viewdistance)*Global.chunksize,0,Global.mapsize),clamp((a.x+Global.viewdistance)*Global.chunksize,0,Global.mapsize)):
				for i in range(clamp((a.y-Global.viewdistance)*Global.chunksize,0,Global.mapsize),clamp((a.y+Global.viewdistance)*Global.chunksize,0,Global.mapsize)):
					set_cell(e,i,-1)
		eraselist=[]

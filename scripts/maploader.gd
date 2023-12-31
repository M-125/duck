extends Node
var positionn=Vector2()
var positionnn=Vector2()
var noise=Noise.new()
var thread=Thread.new()
onready var map=$"../map"
func _ready():
	Global.map1=$"../map"
	Global.map2=$"../map2"
	Global.map3=$"../map3"
	pass
	
func loadmap():
	var pos=(map.world_to_map(map.to_local(Global.playerposition))/Global.chunksize).ceil()
	var matrix=[]
	if pos !=positionn:
		
		
		for e in range(clamp((pos.x-Global.viewdistance)*Global.chunksize,0,Global.mapsize),clamp((pos.x+Global.viewdistance)*Global.chunksize,0,Global.mapsize)):
			var list=[]
			for i in range(clamp((pos.y-Global.viewdistance)*Global.chunksize,0,Global.mapsize),clamp((pos.y+Global.viewdistance)*Global.chunksize,0,Global.mapsize)):
				list.append(noise.get_noise_2d(e,i))

			matrix.append(list)
		positionn=pos
		
		pos-=Vector2(Global.viewdistance,Global.viewdistance)
		pos.x=clamp(pos.x,0,Global.mapsize)
		pos.y=clamp(pos.y,0,Global.mapsize)
		matrix.append(pos*Global.chunksize)
		
		return matrix
	return null
	
	
func _process(delta):
	var pos=(map.world_to_map(map.to_local(Global.playerposition))/Global.chunksize).ceil()
	
	if not thread.is_active() :
		if pos !=positionn:
			thread.start(self,"loadmap")
	elif not thread.is_alive():
		var matrix=thread.wait_to_finish()
		if matrix!=null:for e in [Global.map1,Global.map2,Global.map3]:
			e.loadmap(matrix)




				

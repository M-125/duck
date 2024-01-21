extends Node
var positionn=Vector2()
var positionnn=Vector2()
var noise=Noise.new()
var thread=Thread.new()
var loadedchunks=[]
var canrun=true
onready var map=$"../map"
signal loaded
func _ready():
	Global.map1=$"../map"
	Global.map2=$"../map2"
	Global.map3=$"../map3"
	connect("loaded",self,"loading")
	loading()
	
	pass
	
func loadmap(pos):
	
	var matrix=[]
	if not (pos in loadedchunks):
		
		for e in range(clamp((pos.x*Global.chunksize)-1,-1,Global.mapsize),clamp(((pos.x+1)*Global.chunksize)+1,-1,Global.mapsize)):
			var list=[]
			for i in range(clamp(((pos.y)*Global.chunksize)-1,-1,Global.mapsize),clamp(((pos.y+1)*Global.chunksize)+1,-1,Global.mapsize)):
				list.append(noise.get_noise_2d(e,i))

			matrix.append(list)
		positionn=pos
		
		pos.x=clamp(pos.x,-1,Global.mapsize/16+1)
		pos.y=clamp(pos.y,-1,Global.mapsize/16+1)
		matrix.append(pos*Global.chunksize)
		loadedchunks.append(pos)
		return matrix
	return null
	
	
func loading():
	
	
	var pos=(map.world_to_map(map.to_local(Global.playerposition))/Global.chunksize).round()
	Global.debug.text=str(pos)
	
	
	for e in range(-2,3):for i in range(-2,3):
		var chunk=pos+Vector2(e,i)
		chunk.x=clamp(chunk.x,0,Global.mapsize/Global.chunksize)
		chunk.y=clamp(chunk.y,0,Global.mapsize/Global.chunksize)
		thread.start(self,"loadmap",chunk)
		while thread.is_active():
			yield(get_tree(),"idle_frame")
			if not thread.is_alive():
				var matrix=thread.wait_to_finish()
				if matrix!=null:for m in [Global.map1,Global.map2,Global.map3]:
					m.loadmap(matrix)
				yield(get_tree(),"idle_frame")
				yield(get_tree(),"idle_frame")
		
	for e in range(-Global.viewdistance,Global.viewdistance+1):for i in range(-Global.viewdistance,Global.viewdistance+1):
		var chunk=pos+Vector2(e,i)
		chunk.x=clamp(chunk.x,0,Global.mapsize/Global.chunksize)
		chunk.y=clamp(chunk.y,0,Global.mapsize/Global.chunksize)
		thread.start(self,"loadmap",chunk,0)
		
		while thread.is_active():
			yield(get_tree(),"idle_frame")
			if not thread.is_alive():
				var matrix=thread.wait_to_finish()
				if matrix!=null:for m in [Global.map1,Global.map2,Global.map3]:
					m.loadmap(matrix)
				yield(get_tree(),"idle_frame")
				yield(get_tree(),"idle_frame")
	for chunk in loadedchunks:
		if abs(pos.x-chunk.x) > 5 or  abs(pos.y-chunk.y) > 5:
			for m in [Global.map1,Global.map2,Global.map3]:
					m.erasemap(chunk)
					loadedchunks.erase(chunk)
	emit_signal("loaded")




				

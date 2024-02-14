extends Node
var positionn=Vector2()
var positionnn=Vector2()
var noise=Noise.new()
var thread=Thread.new()
var loadedchunks=[]
var canrun=true
export var Seed=0
export var noisereplace=[]
onready var map=$"../map"
signal loaded
func _ready():
	noise.replace=noisereplace
	if Seed==0:
		Seed=randi()
	noise.seed=Seed
	Global.map1=$"../map"
	Global.map2=$"../map2"
	Global.map3=$"../map3"
	connect("loaded",self,"loading")
	Global.connect("reload",self,"reload")
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
	
	
	
	for e in range(-3,4):for i in range(-3,4):
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
					break
		
	for e in range(-Global.viewdistance,Global.viewdistance+1):
		var canbreak=false
		for i in range(-Global.viewdistance,Global.viewdistance+1):
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
						canbreak=true
			if canbreak:break
		if canbreak:break
	for chunk in loadedchunks:
		if abs(pos.x-chunk.x) > Global.viewdistance or  abs(pos.y-chunk.y) > Global.viewdistance:
			for m in [Global.map1,Global.map2,Global.map3]:
					m.erasemap(chunk)
					loadedchunks.erase(chunk)
	emit_signal("loaded")



func _exit_tree():
	noisereplace=noise.replace
	thread.wait_to_finish()
				


func _on_Timer_timeout():
	noise.seed=Seed
	pass # Replace with function body.

func reload():
	loadedchunks=[]

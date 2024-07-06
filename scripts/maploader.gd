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
var stop=false
signal loaded
func _ready():
	noise.replace=noisereplace
	if Seed==0:
		Seed=randi()
	noise.seed=Seed
	noise.init()
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
				if not(i>=Global.mapsize-1 or e>=Global.mapsize-1):
					list.append(noise.get_noise_2d(e,i))
				else:
					list.append(0)

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
	
	
	
	for e in range(-2,3):for i in range(-2,3):
		var chunk=pos+Vector2(e,i)
		chunk.x=clamp(chunk.x,0,Global.mapsize/Global.chunksize)
		chunk.y=clamp(chunk.y,0,Global.mapsize/Global.chunksize)
		if not chunk in loadedchunks:
			thread.start(self,"loadmap",chunk)
		while thread.is_active():
			yield(get_tree(),"idle_frame")
			if not thread.is_alive():
				var matrix=thread.wait_to_finish()
				if matrix!=null:
					for m in [$"../map",$"../map2",$"../map3"]:
						m.loadmap(matrix)
					break
	for n in range(Global.viewdistance):
		var canbreak=1
		for e in range(-n,n+1):
			
			for i in range(-n,n+1):
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
							canbreak-=1
				if canbreak<0:break
			if canbreak<0:break
		if canbreak<0:break
	for chunk in loadedchunks:
		if abs(pos.x-chunk.x) > Global.viewdistance+1 or  abs(pos.y-chunk.y) > Global.viewdistance+1:
			for m in [Global.map1,Global.map2,Global.map3]:
					m.erasemap(chunk)
					loadedchunks.erase(chunk)
	if stop:
		return
	else:
		emit_signal("loaded")



func _exit_tree():
	noisereplace=noise.replace
	thread.wait_to_finish()
				


func _on_Timer_timeout():
	noise.seed=Seed
	pass # Replace with function body.

func reload():
	var n=200
	stop=true
	while n>0:
		n-=1
		for chunk in loadedchunks:
			
			for m in [Global.map1,Global.map2,Global.map3]:
					m.erasemap(chunk)
					loadedchunks.erase(chunk)
		yield(get_tree(),"idle_frame")
	stop=false
	yield(get_tree().create_timer(4),"timeout")
	emit_signal("loaded")

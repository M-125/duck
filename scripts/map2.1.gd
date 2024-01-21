extends TileMap
var list=[]
var movex=0
var movey=0
var loadedchunks=[]
var wait=0
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
	"rightleftdown":17,
	"rightleftup":5,
	"leftdownup":54,
	"rightdownup":56,
	"downup":55
	,"rightleftdownup":53
}
var positionn
var positionnn
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _process(delta):
	loadmap()
	erasemap()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func loadmap():
	var pos=(world_to_map(to_local(Global.playerposition))/Global.chunksize).round()
#	var viewdistance=Global.viewdistance*Global.chunksize
	for e in range(pos.x-Global.viewdistance/2,pos.x+Global.viewdistance/2):
		for i in range(pos.y-Global.viewdistance/2,pos.y+Global.viewdistance/2):
			var poss=Vector2(clamp(e,0,INF),clamp(i,0,INF))
			loadchunk(Vector2(e,i))
			yield(get_tree(),"idle_frame")
		
			
func erasemap():
	var pos=(world_to_map(to_local(Global.playerposition))/Global.chunksize).round()
	
	for a in loadedchunks:
		if abs(pos.x-a.x)>5 or abs(pos.y-a.y)>5:
			erasechunk(a)
			yield(get_tree(),"idle_frame")

func erasechunk(pos):
	for e in range(clamp((pos.x)*Global.chunksize,0,Global.mapsize),clamp((pos.x+1)*Global.chunksize,0,Global.mapsize)):
		for i in range(clamp((pos.y)*Global.chunksize,0,Global.mapsize),clamp((pos.y+1)*Global.chunksize,0,Global.mapsize)):
			set_cell(e,i,-1)
			loadedchunks.erase(pos)
			if i%16==0:yield(get_tree(), "idle_frame")
func loadchunk(pos):
	if not pos in loadedchunks:
	
		for e in range(clamp((pos.x)*Global.chunksize,0,Global.mapsize),clamp((pos.x+1)*Global.chunksize,0,Global.mapsize)):
			yield(get_tree(), "idle_frame")
			for i in range(clamp((pos.y)*Global.chunksize,0,Global.mapsize),clamp((pos.y+1)*Global.chunksize,0,Global.mapsize)):
				if e==0:
					set_cell(e,i,terrain["left"])
				if i==0:
					set_cell(e,i,terrain["up"])
				if e==Global.mapsize-1:
					set_cell(e,i,terrain["right"])
				if i==Global.mapsize-1:
					set_cell(e,i,terrain["down"])
				if e==0 and i==0:
					set_cell(e,i,terrain["leftup"])
				if e==Global.mapsize-1 and i==0:
					set_cell(e,i,terrain["rightup"])
				if e==0 and i==Global.mapsize-1:
					set_cell(e,i,terrain["leftdown"])
				if e==Global.mapsize-1 and i==Global.mapsize-1:
					set_cell(e,i,terrain["rightdown"])
				if get_cell(e,i)==-1:
					set_cell(e,i,7)
		loadedchunks.append(pos)

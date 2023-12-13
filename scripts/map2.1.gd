extends TileMap
var list=[]
var movex=0
var movey=0
var eraselist=[]
var wait=0
var detectlist=[]
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


# Called when the node enters the scene tree for the first time.
func _ready():
	for e in range(-3,4):
		for i in range(-3,4):
			detectlist.append(Vector2(e,i))
func _process(delta):
	erasemap()
	loadmap()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func loadmap():
	var pos=(world_to_map(to_local(Global.playerposition))/Global.chunksize).round()
#	var viewdistance=Global.viewdistance*Global.chunksize
	if pos !=positionn:
		positionn=pos
		for e in range(clamp((pos.x-Global.viewdistance)*Global.chunksize,0,Global.mapsize),clamp((pos.x+Global.viewdistance)*Global.chunksize,0,Global.mapsize)):
			yield(get_tree(),"idle_frame")
			for i in range(clamp((pos.y-Global.viewdistance)*Global.chunksize,0,Global.mapsize),clamp((pos.y+Global.viewdistance)*Global.chunksize,0,Global.mapsize)):
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
		eraselist.append(pos)
			
func erasemap():
	var pos=(world_to_map(to_local(Global.playerposition))/Global.chunksize).round()
	if pos !=positionnn:
		positionnn=pos
		for a in eraselist:
			var list=[]
			for e in detectlist: 
				list.append(e+pos)
			if not a in list:
				for e in range(clamp((a.x-Global.viewdistance)*Global.chunksize,0,Global.mapsize),clamp((a.x+Global.viewdistance)*Global.chunksize,0,Global.mapsize)):
					for i in range(clamp((a.y-Global.viewdistance)*Global.chunksize,0,Global.mapsize),clamp((a.y+Global.viewdistance)*Global.chunksize,0,Global.mapsize)):
						set_cell(e,i,-1)
					yield(get_tree(),"idle_frame")
				eraselist.erase(a)

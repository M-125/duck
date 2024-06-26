extends TileMap
var list=[]
var map=[]
var badlist=[-1,47,17,20,18,48,50,49]
var finalmap=[]
var noise=Noise.new()
export var myfloor=1
var detectlist=[]

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
	"rightleftdown":53,
	"rightleftup":5,
	"leftdownup":54,
	"rightdownup":56,
	"downup":55
	,"rightleftdownup":53
}

func _process(delta):
	
	if Global.playerfloor>=myfloor:
		set_collision_layer_bit(0,false)
		set_collision_mask_bit(0,false)
		
	else:
		set_collision_layer_bit(0,true)
		set_collision_mask_bit(0,true)
		
	

	
func _ready():pass



func loadmap(matrix:Array):
	var pos=(world_to_map(to_local(Global.playerposition))/Global.chunksize).round()
	
		
	for e in range(1,matrix.size()-2):
		
		if not matrix[e] is Vector2:
			
			for i in range(1,matrix[e].size()-1):
				var blockpos=matrix[matrix.size()-1]+Vector2(e,i)+Vector2(-1,-1)
				var noiser=matrix[e][i]
				
				if noiser>=myfloor :
					
					var side=""
					if (matrix[clamp(e+1,0,matrix.size()-2)][i]<myfloor or blockpos.x==Global.mapsize-1) :
						side+="right"
					if (matrix[clamp(e-1,0,matrix.size()-2)][i]<myfloor or blockpos.x==0) :
						side+="left"
					if (matrix[e][clamp(i+1,0,matrix[e].size()-1)]<myfloor or blockpos.y==Global.mapsize-1) :
						side+="down"
					if (matrix[e][clamp(i-1,0,matrix[e].size()-1)]<myfloor or blockpos.y==0)  :
						side+="up"
				
					if side!="":
						set_cellv(blockpos,terrain[side])
					else:
						set_cellv(blockpos,7)
				else:
					set_cellv(blockpos,-1)
				if i%32==0:yield(get_tree(), "idle_frame")
#func _process(delta):
##	pass
#func erasemap():
#	for e in range(finalmap.size()):
func erasemap(pos):
	
	
	
	for e in range(clamp((pos.x)*Global.chunksize,0,Global.mapsize),clamp((pos.x+1)*Global.chunksize,0,Global.mapsize)):
		for i in range(clamp((pos.y)*Global.chunksize,0,Global.mapsize),clamp((pos.y+1)*Global.chunksize,0,Global.mapsize)):
			set_cell(e,i,-1)
			if i%16==0:yield(get_tree(), "idle_frame")

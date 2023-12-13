extends TileMap
var list=[]
var size=Vector2()
var movex
var movey
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	platform()
func platform():
	randomize()
	size.x=round(rand_range(5,20))
	
	randomize()
	size.y=round(rand_range(5,20))
	randomize()
	movex=round(rand_range(-50,50))
	randomize()
	movey=round(rand_range(-50,50))
	
	for e in range(size.x):
		var row=[]
		for i in range(size.y):
			row.append(7)
		list.append(row)
	var x=0
	var y=0
	
	for e in range(list[0].size()):
		list[0][e]=1
	for e in range(list[list.size()-1].size()):
		list[list.size()-1][e]=19
	
	for e in range(list.size()):
		list[e][0]=6
	for e in range(list.size()):
		var list2=list[e].size()-1
		list[e][list2]=8
	
	
	list[0][0]=0
	var list1=list.size()-1
	list[list1][0]=18
	var list2=list[list.size()-1].size()-1
	list[0][list2]=2
	list[list1][list2]=20
	
	for e in list:
		for i in e:
			set_cell(x+movex,y+movey,i)
			x+=1
		x=0
		y+=1

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

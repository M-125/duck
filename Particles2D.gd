extends Particles2D

var dir=[Vector2(0,1),Vector2(1,0),Vector2(0,-1),Vector2(-1,0)]
var disabled=Vector2(0,1)
var choosed=Vector2(0,0)
var wait=0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	randomize()
	var number=round(rand_range(0,2))
	
	var prevchose=choosed
	var choselist=[]
	randomize()
	number=round(rand_range(0,2))
	for d in dir:
		if d !=disabled:
			choselist.append(d)
	if wait<=0:
		choosed=choselist[number]
		wait=rand_range(0.2,0.5)
	position+=choosed*100*delta
	for d in range(len(dir)):
		if choselist[number]==dir[d]:
			disabled=dir[(d+2)%4]
	while choosed==prevchose*-1:
		var choselistt=[]
		randomize()
		number=round(rand_range(0,2))
		for d in dir:
			if d !=disabled:
				choselistt.append(d)
		if wait<=0:
			choosed=choselistt[number]
			wait=rand_range(0.2,0.5)
		position+=choosed*100*delta
		for d in range(len(dir)):
			if choselistt[number]==dir[d]:
				disabled=dir[(d+2)%4]
		
	
	
	wait-=delta
	pass

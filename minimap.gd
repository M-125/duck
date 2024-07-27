extends TileMap

func _ready():
	for x in range(Global.mapsize): for y in range(Global.mapsize):
		set_cell(x,y,2)

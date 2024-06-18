extends OpenSimplexNoise
class_name Noise
var replace=[]
var file=File.new()
func init():
	Global.connect("save",self,"save")
	if not file.file_exists("user://noise"+str(self.seed)):
		file.open("user://noise"+str(self.seed),File.WRITE)
		for e in range(pow(ceil(Global.mapsize/16)*16,2)):
			file.store_8(0)
		file.close()
		print("created")
	if not file.is_open():
		file.open("user://noise"+str(self.seed),File.READ_WRITE)
func get_noise_2d(x,y):
	if x<0 or y<0:
		return 0
	
	if not file.is_open():
		file.open("user://noise"+str(self.seed),File.READ_WRITE)

	var noiseval
	if readpos(x,y)==0:
		noiseval=stepify(abs(get_noise_2dv(Vector2(x,y)))*10,0.1)
		writepos(x,y,noiseval*10)
	else:noiseval=readpos(x,y)/10
	
	for e in replace:
		var rect=e[0]
		if x>=rect.position.x and x<=rect.end.x and y>=rect.position.y and y<=rect.end.y:
			var level=int(e[1])
			if "<" in e[1] and noiseval >= level:
				noiseval=level-0.01
			elif ">" in e[1] and noiseval <= level:
				noiseval=level+0.01
			elif "<=" in e[1] and noiseval > level:
				noiseval=level-0.01
			elif ">=" in e[1] and noiseval < level:
				noiseval=level+0.01
			elif "=" in e[1]:
				noiseval=level+0.01
	return noiseval
func addzone(rect:Rect2,req:String):
	if not [rect,req] in replace:
		replace.append([rect,req])

func readpos(x,y):
	var chunk=Vector2(floor(x/Global.chunksize),floor(y/Global.chunksize))
	var pos=Vector2(x%Global.chunksize,y%Global.chunksize)
	file.seek((chunk.x*pow(Global.chunksize,2)+(ceil(Global.mapsize/Global.chunksize)*pow(Global.chunksize,2)*chunk.y))+pos.x+(Global.chunksize*pos.y))
	return file.get_8()

func writepos(x,y,val):
	var chunk=Vector2(floor(x/Global.chunksize),floor(y/Global.chunksize))
	var pos=Vector2(x%Global.chunksize,y%Global.chunksize)
	file.seek((chunk.x*pow(Global.chunksize,2)+(ceil(Global.mapsize/Global.chunksize)*pow(Global.chunksize,2)*chunk.y))+pos.x+(Global.chunksize*pos.y))
	
	file.store_8(val)
			

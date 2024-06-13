extends OpenSimplexNoise
class_name Noise
var replace=[]
var file=File.new()
func _init():
	Global.connect("save",self,"save")
func get_noise_2d(x,y):
	
	if not file.file_exists("user://noise"+str(self.seed)):
		file.open("user://noise"+str(self.seed),File.WRITE)
		for e in range(Global.mapsize):for i in range(Global.mapsize):
			file.store_8(0)
		file.close()
		print("created")
	if not file.is_open():
		file.open("user://noise"+str(self.seed))
	print("read")
	var noiseval
	if readpos(x,y)==0:
		writepos(x,y,round(abs(get_noise_2dv(Vector2(x,y)))*10*10))
	noiseval=readpos(x,y)/10
	print("ns",noiseval)
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
	file.seek(x+(Global.mapsize*y))
	return file.get_8()

func writepos(x,y,val):
	file.seek(x+(Global.mapsize*y))
	return file.store_8(val)
			

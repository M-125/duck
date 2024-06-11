extends OpenSimplexNoise
class_name Noise
var replace=[]
var file=File.new()
func get_noise_2d(x,y):
	if file.file_exists("user://noise"+str(self.seed)):
		file.open("user://noise"+str(self.seed),File.WRITE)
		for e in range(Global.mapsize):for i in range(Global.mapsize):
			file.store_8(0)
	
	var noiseval=abs(get_noise_2dv(Vector2(x,y)))*10
	
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

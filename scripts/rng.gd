extends RandomNumberGenerator
class_name Rng
var replace=[Rect2(0,0,30,30)]
func Randi_range(x,y,r1,r2):
	var val=randi_range(r1,r2)
	for e in replace:
		var rect=e
		if x>=rect.position.x and x<=rect.end.x and y>=rect.position.y and y<=rect.end.y:
			val=0
			
	return val
func addzone(rect:Rect2):
	var canadd=true
	for e in replace:
		if e ==rect:
			canadd=false
	if canadd:
		replace.append(rect)

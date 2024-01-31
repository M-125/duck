extends Resource
class_name Rng
var replace=[Rect2(0,0,30,30)]
var Seed:int=0
var state:float=0
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
func randi_range(r1:int,r2:int):
	var modulo=r2-r1
#	print(int(Seed*state))
#	print(r1+abs(int(Seed*state)%modulo),"   ",int(Seed)," ",state," ",modulo," ",int(Seed*state))
	return r1+abs((int(round(Seed*state+(Seed+(7*int(round(state/3)))%modulo/2) ))>>1)%modulo)
func randomize():
	Seed=rand_range(0,65535)
	var string=""
	for e in str(Seed):
		while int(e)%2==0:
			e=str(round(rand_range(1,9)))
		string+=e
	Seed=int(string)
	print("seed",Seed)
func _init():
	self.randomize()

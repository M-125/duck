extends Resource
class_name Rng
var replace=[]
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
	if modulo %2==0: modulo-=1
	var _Seed=int(str(Seed).rstrip("02468"))
	var _state=int(str(state).rstrip("02468"))
	var _r2=int(str(r2).rstrip("02468"))
	var _r1=int(str(r1).rstrip("02468"))
	
	if _r1==0:_r1=1
	if _r2==0:_r2=1
	
	var number=r1+int(round(fmod((_r2*_Seed*_state*13*_r1)+_state/7,modulo)))
	number*=abs(_Seed)
	if number<r1:
		number=r2-number
	number+=r1
	return (number% modulo)+r1
func randomize():
	Seed=rand_range(0,65535)
	var string=""
	for e in str(Seed):
		while int(e)%2==0:
			e=str(round(rand_range(1,9)))
		string+=e
	Seed=int(string)
func _init():
	self.randomize()

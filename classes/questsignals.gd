extends Node
signal enemykilled
signal itemcollected
signal itemcollected_noparam
signal enemykilled_noparam


func has_noparam(name):
	for Signal in get_signal_list():
		if Signal.name==name+"_noparam":
			return true
	return false


func _ready():
	var signalslist=get_signal_list()
	for Signal in signalslist:
		if (not Signal["name"].ends_with("_noparam")) and has_noparam(Signal["name"]):
			connect(Signal["name"],self,"noparam",[Signal["name"]])
			print(Signal["name"])
func noparam(p1,p2="",p3="",p4="",p5="",p6="",p7="",p8="",p9=""):
	var array=[p1,p2,p3,p4,p5,p6,p7,p8,p9]
	var name=""
	for e in range(array.size()):
		if str(array[e])=="":
			name=array[e-1]
			break
	emit_signal(name+"_noparam")

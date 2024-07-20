extends Node
signal enemykilled
signal itemcollected
signal itemcollected_noparam
signal enemykilled_noparam
var savequests=[
	Quest.Quest(
		[Quest.Task("Kill enemies",20,"enemykilled_noparam","quest")]
		,Quest.Reward("",100)),
	
	Quest.Quest(
		[Quest.Task("Collect currencies/materials",500,"itemcollected_noparam","quest")]
		,Quest.Reward("pizza"))
,
	Quest.Quest(
		[Quest.Task("Kill enemies",20,"enemykilled_noparam","quest"),
		Quest.Task("Collect currencies/materials",500,"itemcollected_noparam","quest")]
		,Quest.Reward("rpg"))]

var quests=[]

func has_noparam(name):
	for Signal in get_signal_list():
		if Signal.name==name+"_noparam":
			return true
	return false


func _ready():
	Global.connect("savequests",self,"write_out_quests")
	Global.connect("delquests",self,"del_quests")
	
	var signalslist=get_signal_list()
	for Signal in signalslist:
		if (not Signal["name"].ends_with("_noparam")) and has_noparam(Signal["name"]):
			connect(Signal["name"],self,"noparam",[Signal["name"]])
			print(Signal["name"])
	
	var file=File.new()
	if file.file_exists("res://quests/quest.json"):
		file.open("res://quests/quest.json",File.READ)
		quests=JSON.parse(file.get_as_text()).result
		file.close()


func noparam(p1,p2="",p3="",p4="",p5="",p6="",p7="",p8="",p9=""):
	var array=[p1,p2,p3,p4,p5,p6,p7,p8,p9]
	var name=""
	for e in range(array.size()):
		if str(array[e])=="":
			name=array[e-1]
			break
	emit_signal(name+"_noparam")
	



func write_out_quests():
	var file=File.new()
	var dict=[]
	if file.file_exists("res://quests/quest.json"):
		file.open("res://quests/quest.json",File.READ)
		var result=JSON.parse(file.get_as_text()).result
		if result is Array:
			dict=result
		file.close()
	file.open("res://quests/quest.json",File.WRITE)
	dict.append_array(savequests)
	file.store_string(to_json(dict))

func del_quests():
	Directory.new().remove("res://quests/quest.json")

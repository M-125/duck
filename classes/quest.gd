extends Resource
class_name Quest
export var tasks={}
export var completed=false
export var reward={"coins":0,"item":""}
export var text=""

static func createdict(name,value,Signal,callable="quest"):
	return {"name":name,"signal":Signal,"value":value,"callable":callable}
func _init(array=tasks,coin=reward["coins"],item=reward["item"]):
	
	reward["coins"]=coin
	reward["item"]=item
	print(array)
	if array is Array:
		for e in array:
			Quests.connect(e["signal"],self,e["callable"],[e["name"]])
			tasks[e["name"]]={
				"value":e["value"],
				"callable":e["callable"],
				"signal":e["signal"]
			}
	elif array is Dictionary:
		for key in tasks:
			var e=tasks[key]
			Quests.connect(e["signal"],self,e["callable"],[key])
	maketext()
func quest(name):
	tasks[name]["value"]-=1
	check()
func check():
	for key in tasks:
		var value = tasks[key]["value"]
		if value>0:
			maketext()
			return
	completed=true
func reward():
	Global.small_stuff[0]+=reward["coins"]
	if reward["item"]!="":
		var item=load("res://items/"+reward["item"]+".tscn").instance()
		Global.scene.add_child(item)
		item.global_position=Global.player.global_position
func maketext():
	text=""
	for key in tasks:
		var value=tasks[key]["value"]
		if value >0:
			text+=key.capitalize()+" : "+str(value)
			print(text)
		text+="\n"

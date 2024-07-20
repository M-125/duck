extends Resource
class_name Quest
export var tasks={}
export var completed=false
export var reward={"coins":0,"item":""}
export var text=""



static func Task(name,value,Signal,callable="quest"):
	return {"name":name,"signal":Signal,"value":value,"callable":callable}

static func Reward(item="",coin=0):
	return {"item":item,"coin":coin}

static func Quest(tasks,reward={"item":"","coin":0}):
	return {"tasks":tasks,"rewards":reward}

func _init(array:Dictionary=tasks,coin=reward["coins"],item=reward["item"]):
	
	reward["coins"]=coin
	reward["item"]=item
	print(array)
	if array.has("rewards"):
		for e in array["tasks"]:
			
			Quests.connect(e["signal"],self,e["callable"],[e["name"]])
			
			tasks[e["name"]]={
				"value":e["value"],
				"callable":e["callable"],
				"signal":e["signal"]
			}
		reward["coins"]=array["rewards"]["coin"]
		reward["item"]=array["rewards"]["item"]
	else:
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
	
	for e in range(reward["coins"]):
		yield(Global.get_tree(),"physics_frame")
		yield(Global.get_tree(),"physics_frame")
		yield(Global.get_tree(),"physics_frame")
		var item=load("res://scenes/coin.tscn").instance()
		Global.scene.add_child(item)
		item.global_position=Global.player.global_position
	
	if reward["item"]!="":
		var item=load("res://items/"+reward["item"]+".tscn").instance()
		Global.scene.add_child(item)
		item.global_position=Global.player.global_position
	Global.emit_signal("save")
		
		
func maketext():
	text=""
	for key in tasks:
		var value=tasks[key]["value"]
		if value >0:
			text+=key.capitalize()+" : "+str(value)
			print(text)
		text+="\n"

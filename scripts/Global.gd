extends Node
var map1
var map2
var map3
var playerfloor=0
var playerfalling=false
var playerposition=Vector2()
var player
var wait=1
var ingame
var maps=[]
var speedmod=0
var speedmodmin=0
var speedmodmax=100
var viewdistance=7
var playerontilemap=-1
var playerjump=true
var mapsize=200
var chunksize=16
var small_stuff=[0,0,0,500,0]
var scene
signal valuechange
var nochick =false
enum guistates{game,gui1}
var guistate=guistates.game
var itemcount=1
var endgame=false
var playerpack:PackedScene=null
var savemap:PackedScene=null
var Seed=0
var gamefinished=false
var alertfeed:CanvasLayer
var music:AudioStreamPlayer
var debug:Label
var Debug=true
var itemloot=[load("res://scenes/item.tscn"),item("pizza")]
signal zoomout
signal item
signal reload
signal givemoney
signal kill
signal shake
signal inv
signal horde
signal enemy
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	connect("valuechange",self,"valuechange")
	connect("givemoney",self,"money")
	if !ingame:
		ingame=get_parent().get_node_or_null("map2")!=null
		if ingame:
			playerfloor=4
	if get_node_or_null("alertfeed")==null:
		alertfeed=CanvasLayer.new()
		alertfeed.layer=2
		alertfeed.name="alertfeed"
		add_child(alertfeed)
		music=AudioStreamPlayer.new()
		add_child(music)
		debug=Label.new()
		if Debug:alertfeed.add_child(debug)
	
func in_dict(value,dict:Dictionary,key:String):
	for e in dict:
		if value==dict[key]:return true
	return false
	
	
func item(itemname:String):
	return load("res://items/"+itemname+".tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if guistate<0:
		guistate=0
	if player!=null and is_instance_valid(player):
		scene=player.get_parent()
	if !ingame:
		ingame=get_parent().get_node_or_null("map2")!=null
		if ingame:
			playerfloor=4
#	ingame=get_parent().get_node_or_null("map2")!=null
	
	if map1!=null and map2!=null and map3!=null and maps==[]:
		maps=[map1,map2,map3]
	if wait<0 and not ingame:
		ingame=get_parent().get_node_or_null("map2")!=null
		wait=2
	if !ingame:
		playerfalling=false
		playerfloor=0
		
	if get_parent().get_node_or_null("map2")!=null:
		
		var pp=map1.world_to_map(map1.to_local(playerposition+(Vector2(0,-16)*playerfloor)))
		if wait<=0:
			if playerfloor>3:
				playerfloor=3
			if playerfloor==1:
				if map1.get_cellv(pp)==-1:
				
					playerfalling=true
					emit_signal("valuechange",0)
				else:
					playerfalling=false
			
			if playerfloor==2 :
				if map2.get_cellv(pp)==-1:
					emit_signal("valuechange",1)
					
					playerfalling=true
				else:
					playerfalling=false
			
			if playerfloor==3:
				if map3.get_cellv(pp)==-1:
					playerfalling=true
					emit_signal("valuechange",2)
				else:
					playerfalling=false
			
			if playerfloor==0:
				playerfalling=false
		
		
		
		if playerfloor==1:
			if not map1.get_cellv(pp)==-1:
			
				playerjump=true
			else:
				playerjump=false
		
		if playerfloor==2 :
			if not map2.get_cellv(pp)==-1:
				
				playerjump=true
			else:
				playerjump=false
		
		if playerfloor==3:
			if not map3.get_cellv(pp)==-1:
				playerjump=true
			else:
				playerjump=false
		
		if playerfloor==0:
			playerjump=true
		if playerfloor==4:
			playerjump=false
	else:
		playerjump=playerfloor==0
		playerfalling=not playerjump
		if wait <=0 and playerfloor>0:
			playerfloor-=1
			wait=0.5
			
			
		if playerfloor==0:
			playerfalling=false
			playerjump=true
#		if playerfloor<=2 and maps[clamp(playerfloor-1,0,4)].get_cellv(pp)!=-1:
#			playerfalling=false
	if playerfalling:
		
		speedmod+=delta*120
	else:
		speedmod-=200*delta
	if speedmod<0:
		speedmod=0
	speedmod=clamp(speedmod,speedmodmin,speedmodmax)
	wait-=delta
	if Input.is_action_just_pressed("ui_cancel"):guistate-=1
	if Input.is_action_just_pressed("debug"):
		alertfeed.add_child(load("res://scenes/debug.tscn").instance())


func valuechange(value):
	yield(get_tree().create_timer(0.3),"timeout")
	playerfloor=value



func addsound(sound,pos=Vector2(0,0),volume=0):
	var snd=load("res://sounds/"+sound+".tscn").instance()
#	for e in get_children():
#		if e.name==sound:
#			e.name=str(rand_range(0,200))
#			e.bus="half"
	
	if snd is AudioStreamPlayer2D:
		if pos==Vector2(0,0):
			pos=player.global_position
		snd.position=pos
	snd.name=sound
	add_child(snd)
	snd.volume_db+=volume

	

func reset():
	map1=null
	map2=null
	map3=null
	playerfloor=0
	playerfalling=false
	playerposition=Vector2()
	player=null
	wait=1
	ingame=null
	maps=[]
	speedmod=0
	speedmodmin=0
	speedmodmax=150
	playerontilemap=-1
	playerjump=true
	small_stuff=[0,0,0,0,0]
	scene=null
	nochick =false
	guistate=guistates.game
	itemcount=1
	endgame=false
	playerpack=null
	Seed=0
	gamefinished=false
	savemap=null
	_ready()

func alert(string):
	var alert=load("res://scenes/alert.tscn").instance()
	alert.text=str(string)
	alertfeed.add_child(alert)

func music(Music):
	if Music!="":
		music.stream=load("res://music/"+Music+".mp3")
		music.play()
	else:
		music.stop()
func money(num):
	small_stuff[0]+=int(num)
func debug(object):
	debug.text=str(object)
func shake(strength:float):
	emit_signal("shake",strength)

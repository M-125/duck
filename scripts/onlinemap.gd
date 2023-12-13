
extends Node2D

onready var maps =[$map,$map2,$map3]
signal noisereceived
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Server.map=self
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
	if Global.playerpack!=null:
		var pos =$playerduckie.position
		var small =$playerduckie.smallitems
		$playerduckie.queue_free()
		var pl=Global.playerpack.instance()
		pl.smallitems=small
		pl.get_node("Camera2D").current=false
		pl.position=pos
		add_child(pl)
		if name=="map2":
			pl.get_node("Camera2D").current=true
			$map._init()
			if Global.Seed!=0:
				$map.noise.seed=Global.Seed
			$map._ready()
			
	
	if Server.isserver:Server.rset("Seed",randi())
	else:
		yield(get_tree().create_timer(1),"timeout")
		if Server.Seed is int:
			for e in maps:e.noise.seed=Server.Seed
#		for c in get_children():
#			if "item" in c.name:
#				c.queue_free()
	
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		
		if Global.guistate==Global.guistates.game:
			get_tree().change_scene("res://scenes/mainmenu.tscn")
			Server.disconnected()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):


	
extends Node2D
class_name map
export var firstload=true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.scene=self
	Server.map=self
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Global.ingame=true
	
#	if Global.playerpack!=null:
#		var pos =$playerduckie.position
#		var small =$playerduckie.smallitems
#		$playerduckie.queue_free()
#		var pl=Global.playerpack.instance()
#		pl.smallitems=small
#		pl.get_node("Camera2D").current=false
#		pl.position=pos
#		add_child(pl)
	if firstload and name=="map2":
		firstload=false
		$animation/AnimationPlayer.play("swim")
		$animation/Camera2D.current=true
		yield($animation/AnimationPlayer,"animation_finished")
		$spawn.spawn()
		$animation/Camera2D.current=false
		$animation.visible=false
	elif name=="map2":
		$spawn.spawn()
		
	if name=="map2":
		
		$map._init()
		if Global.Seed!=0:
			$map.noise.seed=Global.Seed
		$map._ready()
		
#	if Server.client!=null:
#		for c in get_children():
#			if "item" in c.name:
#				c.queue_free()
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		
		if Global.guistate<Global.guistates.game:
			
			Server.disconnected()
			get_tree().change_scene("res://scenes/mainmenu.tscn")
			
			
			
	if Global.endgame:
		var enemies=[]
		for e in get_children():
			if "enemy" in e.name:
				enemies.append(e)
		if enemies.size()>10:
			enemies.sort_custom(self,"sorting")
			for e in range(20,enemies.size()):
				enemies[e].queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func sorting(a,b):
	return a.global_position.distance_to(Global.player.global_position)<b.global_position.distance_to(Global.player.global_position)
func _exit_tree():
	Global.savemap=PackedScene.new()
	Global.savemap.pack(self)

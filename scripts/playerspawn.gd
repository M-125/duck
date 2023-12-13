extends Node2D
class_name playerspawn
export var smallitems=false
export var randomspawn=true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if "player" in name:
		name="spawn"
	yield(get_tree().create_timer(0),"timeout")
	var pos=position
	
	var plr
	if Global.playerpack==null:
		plr=load("res://scenes/player.tscn").instance()
	else:
		plr=Global.playerpack.instance()
	plr.position=pos
	plr.smallitems=smallitems
	plr.randomspawn=randomspawn
	get_parent().add_child(plr)
	pass # Replace with function body.


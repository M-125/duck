extends StaticBody2D

var shopmenu=load("res://scenes/shopmenu.tscn")
var pos=Vector2(0,0)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.current_animation="e"
	while not (Global.player !=null and is_instance_valid(Global.player)):
		yield(get_tree(),"idle_frame")
	Global.player.connect("interactshop",self,"showmenu")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Global.player !=null and is_instance_valid(Global.player):
		var distance = global_position.distance_to(Global.player.global_position)
		var deletedist=39*3*40
		if distance>deletedist:
			queue_free() 
		
		
		$e.visible=Global.player in $shoparea.get_overlapping_bodies()
		
	pass

func showmenu():
	if Global.player in $shoparea.get_overlapping_bodies():
		var shopmen=shopmenu.instance()
		shopmen.connect("bought",self,"bought")
		Global.player.get_node("shopui").add_child(shopmen)
		
func bought():
	var item=load("res://scenes/item.tscn").instance()
	Global.scene.add_child(item)
	item.global_position=$Node2D.global_position
	item.item="random"
	item.reload()

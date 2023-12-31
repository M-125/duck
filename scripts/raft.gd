extends Item
var prevparent=null

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	rotatable=false
	pass # Replace with function body.
func reload():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$press_E.visible=selected
	
	if prevparent!=get_parent():
		visible=false
		prevparent=get_parent()
	global_scale=Vector2(3,3)
	global_rotation=0
		
	
	if get_parent()==Global.player.get_node("hrot/helditem"):
		global_position=Global.player.get_node("Sprite").global_position-Vector2(0,32*2)
	
		
	elif get_parent().name in ["item1","item2"]:position=Vector2.ZERO
	visible=true

func use():
	get_parent().remove_child(self)
	Global.player.get_node("rot").add_child(self)
	position=Vector2(32,0)
	var pos=global_position
	get_parent().remove_child(self)
	Global.player.get_parent().add_child(self)
	
	_process(get_process_delta_time())
	global_position=pos
	if get_parent().name=="map2":
		if $"../base".get_cellv($"../base".world_to_map($"../base".to_local(global_position)))==-1:
			var raft=load("res://scenes/finalraft.tscn").instance()
			
			get_parent().add_child(raft)
			raft.global_position=global_position
			raft.dir=global_position-Global.player.global_position
			queue_free()
	return true

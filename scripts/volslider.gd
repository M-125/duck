extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().value=db2linear(AudioServer.get_bus_volume_db(0))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var cursor=get_parent().get_parent().get_node("cursor")
	if overlaps_area(cursor):
		get_parent().rect_scale.y=2
		if OS.has_touchscreen_ui_hint():
			var x=cursor.global_position.x-(global_position.x-$CollisionShape2D.shape.extents.x)
			if x<0:x=0
			x/=2*$CollisionShape2D.shape.extents.x
			x*=get_parent().max_value-get_parent().min_value
			x+=get_parent().min_value
			get_parent().value=x
	else:
		get_parent().rect_scale.y=1
	pass

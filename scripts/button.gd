extends Area2D
class_name button
export var waittime=0.3
export var text=""
export(Color) var color
var curs=false
export var white=true
export var enabled=true
export var invisible=true
var cursor
export var canchangelooks=true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal pressed
var wait=0
# Called when the node enters the scene tree for the first time.
func _ready():
	$TouchScreenButton.shape=$CollisionShape2D.shape
	$TouchScreenButton.position=$CollisionShape2D.position
	$TouchScreenButton.shape_centered=false
	$TouchScreenButton.connect("pressed",self,"_on_TouchScreenButton_pressed")
	for e in get_children():
		if e != $TouchScreenButton:
			e.visible=not invisible
		else:e.visible=true
	for e in get_parent().get_children():
		if e.name=="cursor":
			cursor=e
	if canchangelooks:
		$ColorRect.color=color
		$Label.text=text
	
		if white:
			$Label.add_color_override("font_color",Color.white)
		else:
			$Label.add_color_override("font_color",Color.black)
	
	pass # Replace with function body.




func _process(delta):
	$TouchScreenButton.visible=enabled
	curs=overlaps_area(cursor)
#	curs=false
	
	if wait<=0 and enabled:
		if (Input.is_action_just_released("interact")or Input.is_action_just_released("attack")) and curs:
			emit_signal("pressed")
#			queue_free()
			wait=waittime
		if canchangelooks:
			if curs:
				$ColorRect2.color=Color.greenyellow
			else:
				$ColorRect2.color=Color(0,0,0)
			pass
	wait-=delta

#
#func _on_button_area_entered(area):
#	if area.name=="cursor":
#		curs=true
#	pass # Replace with function body.
#
#
#func _on_button_area_exited(area):
#	if area.name=="cursor":
#		curs=false
#
	pass # Replace with function body.


func _on_TouchScreenButton_pressed():
	
	if canchangelooks:$ColorRect2.color=Color.greenyellow
	emit_signal("pressed")
#	queue_free()
	pass # Replace with function body.

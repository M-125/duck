extends Node2D
var mainmenu=load("res://scenes/mainmenu.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	OS.center_window()
	$Sprite2.set_process(false)
	get_tree().get_root().set_transparent_background(true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	
	yield(get_tree().create_timer(1.5),"timeout")
	get_tree().get_root().set_transparent_background(false)
	OS.window_per_pixel_transparency_enabled=false
	var children=get_children()
	add_child(mainmenu.instance())
	for e in children:
		if "Animated" in e.name:
			children.erase(e)
			e.queue_free()
	
	
	
	yield(get_tree().create_timer(1),"timeout")
	OS.window_borderless=false
	for e in children:
		e.queue_free()
	pass # Replace with function body.


func _on_Timer2_timeout():
	$Sprite2.set_process(true)
	pass # Replace with function body.

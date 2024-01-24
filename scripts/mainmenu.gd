extends Node2D
var wait=0
var duck=PackedScene.new()
# Declare member variables here. Examples:
# var a = 2
# var b = "tex
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.music.stream=null
	if Global.gamefinished:Global.reset()
	Global.ingame=false
	duck.pack($AnimatedSprite28)
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D,  SceneTree.STRETCH_ASPECT_KEEP, Vector2(1024,600),1)
	OS.window_borderless=false
	OS.window_per_pixel_transparency_enabled=false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	wait+=delta
	if wait>1/60:
		if round(rand_range(1,50))==25:
			var ducky=duck.instance()
			ducky.position.y=rand_range(30,570)
			ducky.position.x=-40
			ducky.scale=Vector2(4,4)
			ducky.z_index=-1
			add_child(ducky)
			wait-=1/60
#	pass


func _on_button_pressed():
	get_tree().change_scene("res://scenes/map.tscn")
	
	pass # Replace with function body.


func _on_button2_pressed():
	
	get_tree().change_scene("res://scenes/map2.0.tscn")
	Server.createserver()
	pass # Replace with function body.


func _on_button3_pressed():
	Server.ip=$TextEdit.text
	Server.join()
	yield(Server,"ID_received")
	get_tree().change_scene("res://scenes/map2.0.tscn")
	
	

func _on_button4_pressed():
	if Global.savemap==null:
		get_tree().change_scene("res://scenes/map2.0.tscn")
	else:
		get_tree().change_scene_to(Global.savemap)
	
	pass # Replace with function body.


func _on_button5_pressed():
	var settings=load("res://scenes/settings.tscn").instance()
	settings.position=Vector2(820,354)
	add_child(settings)
	
	pass # Replace with function body.


func _on_button6_pressed():
	OS.shell_open("https://pixelhole.itch.io/pixelholes-overworld-tileset")
	pass # Replace with function body.

#
#func _input(event):
#	var new_event
#	if event is InputEventScreenTouch:
#		if event.pressed:
#			new_event = InputEventMouseButton.new()
#			new_event.position = event.position
#
#
##			new_event.button_index=BUTTON_LEFT
##			new_event.pressed=true
#
#
#		Input.parse_input_event(new_event)


func _on_button7_pressed():
	if $button4.enabled:
		$AnimationPlayer.play("close")
	else:
		$AnimationPlayer.play("open")


func _on_TouchScreenButton_released():
	$TextEdit.grab_focus()
	$OnscreenKeyboard.show()
	pass # Replace with function body.


func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(0,linear2db(value))
	pass # Replace with function body.

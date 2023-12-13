extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.guistate=Global.guistates.gui1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _process(d):
	if Global.guistate<Global.guistates.gui1:
		queue_free()


func moveback():
	$Panel/ScrollContainer.scroll_horizontal-=500
	pass # Replace with function body.


func moveon():
	$Panel/ScrollContainer.scroll_horizontal+=500
	pass # Replace with function body.


func _on_button_pressed():
	Global.guistate-=1
	pass # Replace with function body.



func _on_Control3_crafted():
	Global.endgame=true
	pass # Replace with function body.

func _input(event):
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		$TouchScreenButton.visibility_mode=TouchScreenButton.VISIBILITY_ALWAYS
		$TouchScreenButton3.visibility_mode=TouchScreenButton.VISIBILITY_ALWAYS


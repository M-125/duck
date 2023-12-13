extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TouchScreenButton_pressed():
	Input.action_press("ui_up")


func _on_TouchScreenButton_released():
	Input.action_release("ui_up")

func _on_TouchScreenButton2_pressed():
	Input.action_press("ui_down")


func _on_TouchScreenButton2_released():
	Input.action_release("ui_down")
	
func _on_TouchScreenButton3_pressed():
	Input.action_press("ui_left")


func _on_TouchScreenButton3_released():
	Input.action_release("ui_left")
	
func _on_TouchScreenButton4_pressed():
	Input.action_press("ui_right")


func _on_TouchScreenButton4_released():
	Input.action_release("ui_right")

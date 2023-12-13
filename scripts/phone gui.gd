extends Node2D

func _process(delta):
	visible=OS.has_touchscreen_ui_hint()
		
func _on_TouchScreenButton8_pressed():
	if Input.is_action_pressed("reverse aim"):
		Input.action_release("reverse aim")
	else:
		Input.action_press("reverse aim")

extends Area2D

var curs=false
var price=floor(rand_range(200,1000))
export(Texture) var icon=preload("res://ar2.png")

export(String,"coin","red dye") var need1="coin"
export(int,1,9999) var amount1=1

export(String,"coin","red dye","") var need2
export(int,0,9999) var amount2=0

export(String,"coin","red dye","") var need3
export(int,0,9999) var amount3=0

# Declare member variables here. Examples:

# var a = 2
# var b = "text"
signal pressed
var wait=0
# Called when the node enters the scene tree for the first time.


func _process(delta):
	
	if wait<=0:
		if (Input.is_action_just_released("interact")or Input.is_mouse_button_pressed(BUTTON_LEFT)) and curs:
			_on_TouchScreenButton_pressed()
			wait=1
		if curs:
			$Sprite.modulate=Color.white
		else:
			$Sprite.modulate=Color(1,1,1,0.75)
		pass
	wait-=delta


func _on_button_area_entered(area):
	if area.name=="cursor":
		curs=true
	pass # Replace with function body.


func _on_button_area_exited(area):
	if area.name=="cursor":
		curs=false
		
	pass # Replace with function body.


func _on_TouchScreenButton_pressed():
	
	
	emit_signal("pressed",price)
	queue_free()
	pass # Replace with function body.

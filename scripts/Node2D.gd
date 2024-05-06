extends Area2D
class_name cursor
var mosepos=Vector2()
var hassprite=false
var firstpos
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	firstpos=position
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("recallcursor"):
		reset()
	if get_global_mouse_position()!=mosepos:
		position=get_global_mouse_position()
		mosepos=position
	else:
		var veloc=Vector2(Input.get_joy_axis(0,0)*500*delta,Input.get_joy_axis(0,1)*500*delta)
		position+=veloc
		for e in get_children():
			if e is Sprite:
				hassprite=true
		if veloc!=Vector2(0,0) and not hassprite:
			var sprite=Sprite.new()
			sprite.scale=Vector2(0.1,0.1)
			sprite.texture=load("res://joystick/textures/joystick_tip.png")
			sprite.z_index=5
			add_child(sprite)
			hassprite=true
	pass
func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		position=event.position
#		get_viewport().set_input_as_handled()
	if event is InputEventScreenDrag:

		position=event.position

#		get_viewport().set_input_as_handled()
#
func reset():
	position=firstpos

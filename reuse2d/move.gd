extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var speed=300
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _procces(delta):
	var velocity=Vector2()
	if Input.is_action_pressed("ui_up"):
		velocity.y-=1
	if Input.is_action_pressed("ui_down"):
		velocity.y+=1
	if Input.is_action_pressed("ui_right"):
		velocity.x+=1
	if Input.is_action_pressed("ui_left"):
		velocity.x-=1
	move_and_slide(velocity*speed)
	pass

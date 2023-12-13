extends KinematicBody2D

var id=1
onready var state_machine = $AnimationTree.get("parameters/playback")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func position(vector):
	if global_position!=vector:
		state_machine.travel("walk")
	else:
		state_machine.travel("idle")
	
	global_position=vector
		

func rot(rot):
	$rot.rotation=rot
	
	
	

func _process(delta):
	var rotspeed=($rot.rotation_degrees-$hrot.rotation_degrees)/7.5
	if abs(rotspeed)<0.0001:
		$rot.rotation_degrees=fmod($rot.rotation_degrees,360)
		$hrot.rotation=$rot.rotation
	$hrot.rotation+=rotspeed*delta
	if $hrot/helditem.get_child_count()==1:
		weapon(rotspeed)


func weapon(rotspeed):
	var weapon=$hrot/helditem.get_child(0)
	for enemy in weapon.in_hitbox:
		weapon.in_hitbox.erase(enemy)
		if abs(rotspeed)>10:
			enemy.damage(weapon.damage*rotspeed/10)
	if abs(rotspeed)>10:
		weapon.get_node("particles").emitting=true
	else:
		weapon.get_node("particles").emitting=false
	pass

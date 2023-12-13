extends Node2D
var pos

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pos=position
	position.x+=300
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x+=(pos.x-position.x)*delta*10
	pass


func _on_SpinBox_value_changed(value):
	print(value)
	Global.mapsize=value
	pass # Replace with function body.


func _on_SpinBox2_value_changed(value):
	Global.viewdistance=16*value/Global.chunksize
	print(value)
	pass # Replace with function body.


func _on_SpinBox2_focus_exited():
	Global.viewdistance=$Control/Panel/SpinBox2.value

func _on_SpinBox3_value_changed(value):
	
	Global.chunksize=value
	Global.viewdistance=round(16*$Control/Panel/SpinBox2.value/Global.chunksize)
	print(value)
	pass # Replace with function body.


func _on_SpinBox3_focus_exited():
	Global.chunksize=$Control/Panel/SpinBox3.value



func _on_SpinBox_focus_exited():
	Global.mapsize=$Control/Panel/SpinBox1.value
	pass # Replace with function body.


func _on_renderplus_pressed():
	
	if $Control/Panel/SpinBox2.value+$Control/Panel/SpinBox2.step<=$Control/Panel/SpinBox2.max_value:
		_on_SpinBox2_value_changed($Control/Panel/SpinBox2.value+$Control/Panel/SpinBox2.step)
		$Control/Panel/SpinBox2.value+=$Control/Panel/SpinBox2.step
	pass # Replace with function body.


func _on_renderminus_pressed():
	if $Control/Panel/SpinBox2.value-$Control/Panel/SpinBox2.step>=$Control/Panel/SpinBox2.min_value:
		_on_SpinBox2_value_changed($Control/Panel/SpinBox2.value-$Control/Panel/SpinBox2.step)
		$Control/Panel/SpinBox2.value-=$Control/Panel/SpinBox2.step


func _on_mapplus_pressed():
	if $Control/Panel/SpinBox.value+$Control/Panel/SpinBox.step<=$Control/Panel/SpinBox.max_value:
		_on_SpinBox_value_changed($Control/Panel/SpinBox.value+$Control/Panel/SpinBox.step)
		$Control/Panel/SpinBox.value+=$Control/Panel/SpinBox.step
	pass # Replace with function body.


func _on_mapminus_pressed():
	if $Control/Panel/SpinBox.value-$Control/Panel/SpinBox.step>=$Control/Panel/SpinBox.min_value:
		_on_SpinBox_value_changed($Control/Panel/SpinBox.value-$Control/Panel/SpinBox.step)
		$Control/Panel/SpinBox.value-=$Control/Panel/SpinBox.step

func _on_chunkplus_pressed():
	if $Control/Panel/SpinBox2.value+$Control/Panel/SpinBox3.step<=$Control/Panel/SpinBox3.max_value:
		_on_SpinBox3_value_changed($Control/Panel/SpinBox3.value+$Control/Panel/SpinBox3.step)
		$Control/Panel/SpinBox3.value+=$Control/Panel/SpinBox3.step
	pass # Replace with function body.


func _on_chunkminus_pressed():
	if $Control/Panel/SpinBox3.value-$Control/Panel/SpinBox3.step>=$Control/Panel/SpinBox3.min_value:
		_on_SpinBox3_value_changed($Control/Panel/SpinBox3.value-$Control/Panel/SpinBox3.step)
		$Control/Panel/SpinBox3.value-=$Control/Panel/SpinBox3.step

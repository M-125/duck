tool
extends Control
class_name craftbutton

var curs=false
var price=floor(rand_range(200,1000))
export var isunique=false
export(PackedScene) var uniqueitem=null
export(String,"sword","amethyst sword") var item="sword"
var needlist=["coin","red dye","white dye","wood","amethyst"]
export(int,"coin","red dye","white dye","wood","amethyst") var need1=0
export(int,1,9999) var amount1=1

export(int,"coin","red dye","white dye","wood","amethyst","") var need2
export(int,0,9999) var amount2=0

export(int,"coin","red dye","white dye","wood","amethyst","") var need3
export(int,0,9999) var amount3=0

signal crafted
# Declare member variables here. Examples:

# var a = 2
# var b = "text"
signal pressed
var wait=0.5
# Called when the node enters the scene tree for the first time.

func _ready():
	if isunique:
		var inst=uniqueitem.instance()
		var clas=ClassDB.get_parent_class(inst.get_class())
		$button/Sprite.texture=inst.get_node("Sprite").texture
	else:
		$button/Sprite.texture=Item.get_img(item)
	var needs=[need1,need2,need3]
	var sprites=[$button/ColorRect/Sprite,$button/ColorRect/Sprite2,$button/ColorRect/Sprite3]
	var amount=[amount1,amount2,amount3]
	var labels=[$button/ColorRect/Label,$button/ColorRect/Label2,$button/ColorRect/Label3]
	
	for e in needs.size():
		var need=needs[e]
		if need<=needlist.size()and amount[e]>0:
			
			labels[e].text=str(amount[e])
			sprites[e].frame=need
			labels[e].visible=true
			sprites[e].visible=true
		else:
			
			labels[e].visible=false
			sprites[e].visible=false
	

func _process(delta):
	if not Engine.editor_hint:
		if wait<=0:
			if (Input.is_action_just_released("interact")or Input.is_mouse_button_pressed(BUTTON_LEFT)) and curs:
				_on_TouchScreenButton_pressed()
				
			if curs:
				$button/Sprite.modulate=Color.white
			else:
				$button/Sprite.modulate=Color(1,1,1,0.75)
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
	wait=0.5
	var needs=[need1,need2,need3]
	for e in needs:
		if e>=needlist.size():
			needs.erase(e)
	var cancraft=true
	for e in range(needs.size()):
		if not(Global.small_stuff[needs[e]]-[amount1,amount2,amount3][e])>=0:
			cancraft=false
	
	if cancraft:
		emit_signal(("crafted"))
		for e in range(needs.size()):
			Global.small_stuff[needs[e]]-=[amount1,amount2,amount3][e]
		
		
		if uniqueitem==null:
			var crafteditem=preload("res://scenes/item.tscn").instance()
			crafteditem.item=item
			Global.player.get_parent().add_child(crafteditem)
			crafteditem.global_position=Global.player.position
		else:
			var item=uniqueitem.instance()
			Global.player.get_parent().add_child(item)
			item.global_position=Global.player.position
		Global.guistate-=1
	else:
		Global.alert("You need more resources!")
	pass # Replace with function body.



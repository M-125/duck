extends KinematicBody2D
class_name Player
var wait=0
var wait2=5
var select=[]
var lookat=0
export var hp=100
export var randomspawn=true
onready var guicam=$"ui/gui"
onready var items=[$hrot/helditem,$ui/item1,$ui/item2]
onready var state_machine = $AnimationTree.get("parameters/playback")
var quack=load("res://sounds/quack.tscn")
var gameover=false
var lowestdifference=90
var releasetime
var pressedbuttons=[0,0,0,0]
var canshoot=false
var nomove=false
var interacttime=0
var clickattack=0
var localplayer=true
var nohitbox=[]
var clickend=false
var chargetime=0
signal interactshop
signal interact
var lastveloc:Vector2
var invincible=false
export var onmapposition=Vector2(0,0)
onready var ITEM1=$ui/item1
onready var ITEM2=$ui/item2
export var smallitems=false
var stun=0
var velocpredict=Vector2(0,0)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var speed=300
# Called when the node enters the scene tree for the first time.





func move(delta):
	var helditem=null
	if $hrot/helditem.get_child_count()==1:
		helditem=$hrot/helditem.get_child(0)
	var velocity=Vector2(0,0)
	
	
	
	if helditem!=null and not helditem.isgun:
		helditem.charged=chargetime>helditem.chargetime
	#true if weapon charged
	
	if Input.is_action_pressed("attack") and helditem !=null:
		if not helditem.isgun:chargetime+=delta
		if helditem.isgun:helditem.shot()
#	charging weapon/shooting
	
	if Input.is_action_just_released("attack") and clickattack<0:
		clickend=false
		clickattack=0.3
		if helditem!=null and not helditem.isgun:
			$hrot.rotation_degrees+=360
			
			if helditem.charged:
				helditem.ability()
			
			chargetime=0
	#click--> attack
	clickattack-=delta
	
	
	
	if Input.is_action_pressed("ui_up"):
		velocity.y-=1
		pressedbuttons[0]=releasetime
	if Input.is_action_pressed("ui_down"):
		velocity.y+=1
		pressedbuttons[1]=releasetime
	if Input.is_action_pressed("ui_right"):
		velocity.x+=1
		pressedbuttons[3]=releasetime
	if Input.is_action_pressed("ui_left"):
		velocity.x-=1
		pressedbuttons[2]=releasetime
	if get_node_or_null("ui/ViewportContainer/UI/phone gui/Virtual joystick") !=null:
		velocity+=$"ui/ViewportContainer/UI/phone gui/Virtual joystick".get_output().normalized()

	if Input.is_joy_known(0)and Vector2(0,0).distance_to(Vector2(Input.get_joy_axis(0,0),Input.get_joy_axis(0,1)))>=0.5:
		velocity+=Vector2(Input.get_joy_axis(0,0),Input.get_joy_axis(0,1))
	
	#	movement input
	velocity=velocity.normalized()
	
	
	if velocity.x>0:
		
		$Sprite.flip_h=false
	elif velocity.x<0:
		
		$Sprite.flip_h=true
		
		
	var velocit=Vector2(0,0)
	
	if pressedbuttons[0]>0:
		velocit.y-=1
	if pressedbuttons[1]>0:
		velocit.y+=1
	
	if pressedbuttons[2]>0:
		velocit.x-=1
	if pressedbuttons[3]>0:
		velocit.x+=1
	#release delay for easier stop and aim at direction ???
	var joystick=get_node_or_null("ui/ViewportContainer/UI/phone gui/Virtual joystick")
	if joystick==null:
		joystick=VirtualJoystick.new()
	if (joystick.get_output().normalized()!=Vector2(0,0)
	or Input.is_joy_known(0)and Vector2(0,0).distance_to(Vector2(Input.get_joy_axis(0,0),Input.get_joy_axis(0,1)))>=0.5
	):
		velocit=velocity
	
	
	
	
	
	
	
	
	if not Global.playerfalling:
		if velocity==Vector2(0,0):
			state_machine.travel("idle")
		else:
			state_machine.travel("walk")
	
	
	
			
	else:
		state_machine.travel("FLY")
	#animation
	
	if velocity!=Vector2.ZERO and clickend:
		lastveloc=((velocit*16)
			)
		
		
	if Input.is_action_pressed("reverse aim"):
		$rot.look_at(to_global(-lastveloc+
			(Vector2(0,-16)*Global.playerfloor)))
	else:
		$rot.look_at(to_global(lastveloc + (Vector2(0,-16)*Global.playerfloor)))
#	look where you move (or reverse)
	erot()
	if lowestdifference<35 and helditem!=null:
		if helditem.isgun:
			$rot.look_at(
				to_global(Vector2(1,0).rotated(deg2rad(lookat))
				+(Vector2(0,-16)*Global.playerfloor)
				))
			
			canshoot=true
		else:
			canshoot=false
	else:
		canshoot=false
	#TODO:canshoot should be deleted
#	aim at sumthing
	
	var rotspeed=($rot.rotation_degrees-$hrot.rotation_degrees)/7.5
	
	if abs(rotspeed)<0.001:
		$rot.rotation_degrees=fmod($rot.rotation_degrees,360)
		$hrot.rotation=$rot.rotation
	
	
	
	if $hrot/helditem.get_child_count()==1:if $hrot/helditem.get_child(0).rotatable:
		$hrot.rotation+=rotspeed*delta*1.3
#	rotate item if rotatable
	if $hrot/helditem.get_child_count()==1:
		if clickattack>0:
			rotspeed=15
		weapon(rotspeed)
#	if clickattacking do damage of 15 rotspeed
	
	if velocity!=Vector2.ZERO:
		nomove=false
		if helditem!=null:helditem.cancel()
	
	if $hrot/helditem.get_child_count()==1:if not $hrot/helditem.get_child(0).rotatable:
		$hrot.rotation=0
	velocpredict=move_and_slide(velocity*(speed+Global.speedmod))
	
	



func interact():
	
	
	
	for e in select:
		if e.get_parent()==$hrot/helditem:
			select.erase(e)
	if select!=[]:
		select[0].selected=true
		if Input.is_action_just_pressed("interact"):
			
			if select[0].interact(self):
				return
#	interact with item on floor
	if Input.is_action_just_pressed("interact"):
		if openchest():
			return
		if houses():
			return
#			interact with chests houses
	if $hrot/helditem.get_child_count()==1:
		var helditem=$hrot/helditem.get_child(0)
		
		if Input.is_action_just_pressed("interact"):
			
			nomove=true
			if helditem.Use():
				return
#interact with helditems like pizza
	if Input.is_action_just_pressed("interact"):
		emit_signal("interactshop")
		emit_signal("interact")
#shop and interactarea
	
	
	
	
		
		
		


func weapon(rotspeed):
	
	var weapon=$hrot/helditem.get_child(0)
	if clickattack<0 and !clickend:
		nohitbox=[]
		
		clickend=true
#	end of clickattack
	
	
#
#	if clickattack>0:
#
#			if weapon.rotatable:for enemy in weapon.hitbox:
#				if abs(rotspeed)>=10 and is_instance_valid(enemy) and (not enemy in nohitbox):
#					var knock=weapon.calc_knockback(abs(weapon.damage*rotspeed/10),enemy)
#
#					enemy.damage(weapon.damage*rotspeed/10,
#					knock
#					)
#					nohitbox.append(enemy)
#	attack enemy in weapon hitbox clickattack
	
	if weapon.rotatable:for enemy in weapon.in_hitbox:
		
				
				
				
				
		weapon.in_hitbox.erase(enemy)
		if abs(rotspeed)>=10 and is_instance_valid(enemy) and  not weapon.isgun:
			var knock=weapon.calc_knockback(abs(weapon.damage*rotspeed/10),enemy)
			
			enemy.damage(weapon.damage*rotspeed/10,
			knock
			)
#	damage depending on rotspeed
	if weapon.rotatable and not weapon.isgun and weapon.get_node_or_null("particles")!=null:
		if abs(rotspeed)>=10:
			weapon.get_node("particles").emitting=true
		else:
			weapon.get_node("particles").emitting=false
	pass





	
	
	


func item_manager():
	if Input.is_action_just_pressed("item1"):
		
		var temp =ITEM1.get_child(0)
		var temp2=$hrot/helditem.get_child(0)
		if ITEM1.get_child_count()>0:
			ITEM1.remove_child(temp)
		
		if $hrot/helditem.get_child_count()>0 :
			$hrot/helditem.remove_child(temp2)
		$hrot/helditem.add_child(temp)
		if temp!=null:temp._process(get_process_delta_time())
		ITEM1.add_child(temp2)
		if temp2!=null:temp2._process(get_process_delta_time())
	
	
	if Input.is_action_just_pressed("item2"):
		
		var temp =ITEM2.get_child(0)
		var temp2=$hrot/helditem.get_child(0)
		if ITEM2.get_child_count()>0:
			ITEM2.remove_child(temp)
		
		if $hrot/helditem.get_child_count()>0 :
			$hrot/helditem.remove_child(temp2)
		$hrot/helditem.add_child(temp)
		if temp!=null:temp._process(get_process_delta_time())
		ITEM2.add_child(temp2)
		if temp2!=null:temp2._process(get_process_delta_time())
		
		
		
	
	
	
	if Input.is_action_just_pressed("drop") and $hrot/helditem.get_child_count()==1:
		var item=$hrot/helditem.get_child(0)
		var itempos=item.global_position
		
		item.get_parent().remove_child(item)
		get_parent().add_child(item)
		item.global_position=itempos
		Server.getsyncer(item).syncnow()


func _ready():
	Global.connect("inv",self,"inv")
	if Server.isconnect():
		if name=="playerduckie":
			name=str(Server.ID)+"player"
		elif name!=str(Server.ID)+"player":
			$ui/ViewportContainer.free()
			$ui.visible=false
	if $ui.visible:
		Global.player=self
	
	var canbecamera=true
	for e in get_parent().get_children():
		if e is Camera2D:
			canbecamera=false
	localplayer=int(name)==Server.ID
	
	if canbecamera:
		$Camera2D.current=int(name)==Server.ID
		yield(get_tree(),"idle_frame")
		print($Camera2D.current)
	
	Global.connect("zoomout",self,"zoomout")
	Global.connect("item",self,"spawnitem")
	Global.connect("enemy",self,"spawnenemy")
	if get_parent().get_node_or_null("MultiPlayerSpawner") != null:
		get_parent().get_node_or_null("MultiPlayerSpawner").add_node(self)
	if onmapposition!=Vector2(0,0) and get_parent().name=="map2":
		position=onmapposition
	if smallitems:
		
		for e in range(2):
			var prev=[ITEM1,ITEM2]
			var now=[$item1,$item2]
			var temp =prev[e].get_child(0)
			if temp!=null:
				prev[e].remove_child(temp)
				now[e].add_child(temp)
		ITEM1=$item1
		ITEM2=$item2
	else:
		for e in range(2):
			var prev=[$item1,$item2]
			var now=[$ui/item1,$ui/item2]
			var temp =prev[e].get_child(0)
			if temp!=null:
				prev[e].remove_child(temp)
				now[e].add_child(temp)
		ITEM1=$ui/item1
		ITEM2=$ui/item2
	items=[$hrot/helditem,ITEM1,ITEM2]
	connect("tree_exiting",self,"exit_tree")
	if OS.has_touchscreen_ui_hint():
		$"ui/ViewportContainer/UI/phone gui".visible=true
	Global.nochick=true
	releasetime=0.05
	randomize()
	Global.playerfloor=3
	Global.playerfalling=true
	if randomspawn:
		position+=Vector2(rand_range(-100,100),rand_range(100,-100))
	
	
	state_machine.start("idle")
	yield(get_tree().create_timer(2),"timeout")
	Global.nochick=false
	pass # Replace with function body.


func _process(delta):
	if localplayer:
		$ui/ColorRect.color.a=clamp($ui/ColorRect.color.a-(delta*2),0,0.5)
		interacttime-=delta
		stun-=delta
		Global.playerfloor=clamp(Global.playerfloor,0,4)
		releasebuttons(delta)
		
		if Input.is_action_just_released("craft"):
			var canadd=true
			for e in $ui.get_children():   if e.is_in_group("craft"):   canadd=false
			if canadd:$ui.add_child(preload("res://scenes/craftmenu.tscn").instance())
		
		
		progressbar(delta)
		$ui/ProgressBar.value=hp
		var zoom=(Global.speedmod/1000)
		var zoom1=(guicam.scale.x+1-zoom+1+1)/4
		guicam.scale=Vector2(zoom1,zoom1)
	#	Vector2(1,1)-
		if Global.guistate == Global.guistates.game and stun <0:
			move(delta)
		interact()
		item_manager()
		Global.playerposition=global_position
		jump()
		
		wait +=delta



func _on_Area2D_area_entered(area):
	if "item" in area.name.to_lower():
		var e=true
		for i in [ITEM1,ITEM2]:
			if area in i.get_children():
				e=false
		if e: select.append(area)
	pass # Replace with function body.


func _on_Area2D_area_exited(area):
	if "item" in area.name.to_lower():
		select.erase(area)
		area.selected=false
	pass # Replace with function body.
	
	




func jump():
	for e in [$Area2D,$Sprite,$CollisionShape2D,$hrot,$rot,$erot]:
		e.position=Vector2(0,-16)*Global.playerfloor
	if Input.is_action_just_pressed("jump")and Global.playerjump:
		Global.playerfloor+=1
		Global.playerfalling=true
		Global.wait=0.5
	



func quack():
	randomize()
	if round(rand_range(0,100))==1:
		var qck=quack.instance()
		add_child(qck)


func dmg(dmg,veloc=Vector2(),stun=0):
	if invincible:return
	$ui/ColorRect.color.a=0.5
	Global.addsound("playerdamage")
	state_machine.travel("damage")
	var label=load("res://scenes/damagemeter.tscn").instance()
	label.get_node("Label").text=str(round(abs(dmg)))
	get_parent().add_child(label)
	label.global_position=global_position
	hp-=dmg
	self.stun=stun
	$Camera2D.position+=Vector2(rand_range(-50,50),rand_range(-50,50))
	if  !gameover and hp<=0:
		
		set_process(false)
		$ui.add_child(load("res://gameover.tscn").instance())
		state_machine.stop()
		state_machine.start("death")
		gameover=true
		Global.gamefinished=true
		
	$ui/ProgressBar.value=hp
pass # Replace with function body.




func progressbar(delta):
	$ui/ProgressBar2.value-=($ui/ProgressBar2.value-$ui/ProgressBar.value)*delta*3




func erot():
	lowestdifference=90
	var found=false
	for e in get_parent().get_children():
		
		if e is enemy and e.global_position.distance_to(global_position)<1024:
			found=true
			$erot.look_at(e.global_position)
			var r=fmod($rot.rotation_degrees,360)
			var i =fmod($erot.rotation_degrees,360.0)
			if r <0:
				r+=360
			if i <0:
				i+=360
			if abs(r-i)<lowestdifference:
				lowestdifference=abs(r-i)
				lookat=$erot.rotation_degrees
	
			





func releasebuttons(delta):
	for i in range(4):
		pressedbuttons[i]-=delta

func openchest():
	var chestmap=get_parent().get_node_or_null("chests")
	
	if chestmap!=null:
		var playerpos=chestmap.world_to_map(chestmap.to_local(global_position))
		for e in range(-1,2):
			for i in range(-1,2):
				var tilepos=playerpos+Vector2(e,i)
				if chestmap.get_cellv(tilepos)==0:
					
					var item=Global.itemloot[floor(rand_range(0,len(Global.itemloot)))].instance()
					item.item="random"
					chestmap.set_cellv(tilepos,-1)
					chestmap.openchests.append(tilepos)
					get_parent().add_child(item)
					item.global_position=chestmap.to_global(chestmap.map_to_world(tilepos))+Vector2(8,8)
					for _a in range(rand_range(12,40)):
						var coin=load("res://scenes/coin.tscn").instance()
						
						
						get_parent().add_child(coin)
						coin.global_position=chestmap.to_global(chestmap.map_to_world(tilepos))+Vector2(8,8)
					return true
	return false
					
					
func houses():
	var e=$Area2D.overlaps_body(Global.scene.get_node("houses"))
#	Global.alert(e)
	if e:
#		Global.alert("inside")
		var i=get_tree().change_scene("res://scenes/house.tscn")
		
		return true
	return false

func exit_tree():
	if get_parent().name=="map2":
		onmapposition=position
	if Global.playerpack==null:
			Global.playerpack=PackedScene.new()
	Global.playerpack.pack(self)
	
	
func zoomout(num):
	$Camera2D.zoom=Vector2(num,num)
func spawnitem(tem):
	var item=load("res://items/"+tem+".tscn")
	if item!=null:
		item=item.instance()
		print("res://items/"+tem+".tscn")
		Global.scene.add_child(item)
		item.global_position=global_position
func spawnenemy(enemy):
	var item=load("res://enemies/"+enemy+".tscn")
	if item!=null:
		item=item.instance()
		print("res://items/"+enemy+".tscn")
		Global.scene.add_child(item)
		item.global_position=global_position


func inv():
	invincible=!invincible

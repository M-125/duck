extends KinematicBody2D
var wait=0
var wait2=5
var select=[]
var lookat=0
var hp=100
onready var guicam=$"ui/gui"
onready var items=[$hrot/helditem,$item1,$item2]
onready var state_machine = $AnimationTree.get("parameters/playback")
var quack=load("res://sounds/quack.tscn")
var gameover=false
var lowestdifference=90
var releasetime=0.05
var pressedbuttons=[0,0,0,0]
var canshoot=false
var nomove=false
var interacttime=0
var clickattack=0
var nohitbox=[]
var clickend=false
var chargetime=0
signal interactshop
var lastveloc:Vector2
var Floor=4
var waitbeforeinput=2
var onlineveloc=Vector2.ZERO
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var speed=300
# Called when the node enters the scene tree for the first time.


func islocalplayer():
	return Server.ID==int(name)


func move(delta):
	var helditem=null
	if $hrot/helditem.get_child_count()==1:
		helditem=$hrot/helditem.get_child(0)
	var velocity=Vector2(0,0)
	
	
	
	if helditem!=null:
		helditem.charged=chargetime>helditem.chargetime
		
	
	if Input.is_action_pressed("attack"):
		chargetime+=delta
		
	if Input.is_action_just_released("attack") and clickattack<0:
		clickend=false
		clickattack=0.3
		$hrot.rotation_degrees+=60
		$rot.rotation_degrees-=60
		if helditem!=null:
			if helditem.chargetime<chargetime:
				helditem.ability()
		chargetime=0
	
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
	velocity+=$"ui/ViewportContainer/UI/phone gui/Virtual joystick".get_output().normalized()
	
	if Input.is_joy_known(0)and Vector2(0,0).distance_to(Vector2(Input.get_joy_axis(0,0),Input.get_joy_axis(0,1)))>=0.5:
		velocity+=Vector2(Input.get_joy_axis(0,0),Input.get_joy_axis(0,1))
	
	
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
	
	if ($"ui/ViewportContainer/UI/phone gui/Virtual joystick".get_output().normalized()!=Vector2(0,0)
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
	if velocity!=Vector2.ZERO and clickend:
		lastveloc=((velocit*16)
			)
		
		
	if Input.is_action_pressed("reverse aim"):
		$rot.look_at(to_global(-lastveloc+
			(Vector2(0,-16)*Global.playerfloor)))
	else:
		$rot.look_at(to_global(
				lastveloc+
				(Vector2(0,-16)*Global.playerfloor)
				))
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
			
	if canshoot:
		helditem.shot()
	var rotspeed=($rot.rotation_degrees-$hrot.rotation_degrees)/7.5
	
	if abs(rotspeed)<0.0001:
		$rot.rotation_degrees=fmod($rot.rotation_degrees,360)
		$hrot.rotation=$rot.rotation
	
	if $hrot/helditem.get_child_count()==1:if $hrot/helditem.get_child(0).rotatable:
		$hrot.rotation+=rotspeed*delta
	
	if $hrot/helditem.get_child_count()==1:
		if clickattack>0:
			rotspeed=15
		weapon(rotspeed)
	
	
	if velocity!=Vector2.ZERO:
		nomove=false
	
	if $hrot/helditem.get_child_count()==1:if not $hrot/helditem.get_child(0).rotatable:
		$hrot.rotation=0
	move_and_slide(velocity*(speed+Global.speedmod))
	rpc_unreliable("updatepos",global_position,$hrot.rotation,Global.playerfloor,(velocity*(speed+Global.speedmod)))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.



func interact():
	
	
	
	for e in select:
		if e.get_parent()==$hrot/helditem:
			select.erase(e)
	if select!=[]:
		select[0].selected=true
		if Input.is_action_just_pressed("interact"):
			
			select[0].interact(self)
			
			return
	
	if Input.is_action_just_pressed("interact"):
		rpc("openchest")
#		emit_signal("interactshop")
	

	if $hrot/helditem.get_child_count()==1:
		var helditem=$hrot/helditem.get_child(0)

		if Input.is_action_just_pressed("interact"):
			if helditem.isheal and not nomove:
				nomove=true
				interacttime=helditem.healingtime
			else:helditem.use()


		if interacttime<=0 and nomove and helditem.isheal:
			hp+=helditem.healing
			helditem.rpc("delete")
			nomove=false



func weapon(rotspeed):
	
	
	if clickattack<0 and !clickend:
		nohitbox=[]
		$rot.rotation_degrees+=60
		clickend=true
	
	
	var weapon=$hrot/helditem.get_child(0)
	
	if clickattack>0:
			
			
			
			
			if weapon.rotatable:for enemy in weapon.hitbox:
				if abs(rotspeed)>=10 and is_instance_valid(enemy) and (not enemy in nohitbox):
					var knock=weapon.calc_knockback(weapon.damage*rotspeed/10,enemy)
			
					enemy.damage(weapon.damage*rotspeed/10,
					knock
					)
					nohitbox.append(enemy)
	if weapon.rotatable:for enemy in weapon.in_hitbox:
		
				
				
				
				
		weapon.in_hitbox.erase(enemy)
		if abs(rotspeed)>=10 and is_instance_valid(enemy):
			var knock=weapon.calc_knockback(weapon.damage*rotspeed/10,enemy)
			
			enemy.damage(weapon.damage*rotspeed/10,
			knock
			)
	if weapon.rotatable:
		if abs(rotspeed)>=10:
			weapon.get_node("particles").emitting=true
		else:
			weapon.get_node("particles").emitting=false
	pass





	
	
	


func item_manager():
	if Input.is_action_just_pressed("item1"):
		
		var temp =$item1.get_child(0)
		var temp2=$hrot/helditem.get_child(0)
		if $item1.get_child_count()>0:
			$item1.remove_child(temp)
		
		if $hrot/helditem.get_child_count()>0 :
			$hrot/helditem.remove_child(temp2)
		$hrot/helditem.add_child(temp)
		if temp!=null:temp._process(get_process_delta_time())
		$item1.add_child(temp2)
		if temp2!=null:temp2._process(get_process_delta_time())
	
	
	if Input.is_action_just_pressed("item2"):
		
		var temp =$item2.get_child(0)
		var temp2=$hrot/helditem.get_child(0)
		if $item2.get_child_count()>0:
			$item2.remove_child(temp)
		
		if $hrot/helditem.get_child_count()>0 :
			$hrot/helditem.remove_child(temp2)
		$hrot/helditem.add_child(temp)
		if temp!=null:temp._process(get_process_delta_time())
		$item2.add_child(temp2)
		if temp2!=null:temp2._process(get_process_delta_time())
		
		
		
	
	
	
	if Input.is_action_just_pressed("drop") and $hrot/helditem.get_child_count()==1:
		var item=$hrot/helditem.get_child(0)
		item.rpc("pickup",get_parent().get_path())


func _ready():
	state_machine.start("idle")
	if name=="e":
		name=str(Server.ID)+"player"
	if islocalplayer():
		Global.nochick=true
		Global.player=self
		releasetime=0.05
		randomize()
		Global.playerfloor=3
		Global.playerfalling=true
		position+=Vector2(rand_range(-100,100),rand_range(100,-100))
		if get_parent().name!="mainmenu":
			$Camera2D.current=true
		
		yield(get_tree().create_timer(2),"timeout")
		Global.nochick=false
	state_machine.start("idle")
	pass # Replace with function body.


func _process(delta):
	
	if islocalplayer() and get_node_or_null("loading")==null:
		interacttime-=delta
		
		Global.playerfloor=clamp(Global.playerfloor,0,4)
		releasebuttons(delta)
		
		if Input.is_action_just_released("craft"):
			var canadd=true
			for e in $ui.get_children():   if e.is_in_group("craft"):   canadd=false
			if canadd:$ui.add_child(preload("res://scenes/craftmenu.tscn").instance())
		
		
		progressbar(delta)
		$ui/ProgressBar.value=hp
		quack()
		var zoom=(Global.speedmod/1000)
		var zoom1=(guicam.scale.x+1-zoom+1+1)/4
		guicam.scale=Vector2(zoom1,zoom1)
	#	Vector2(1,1)-
			
		move(delta)
		interact()
		item_manager()
		
		Global.playerposition=global_position
		jump()
	
		wait +=delta
		
		rpc_unreliable("animation",state_machine.get_current_node(),$Sprite.flip_h)
	else:
		for e in [$Area2D,$Sprite,$CollisionShape2D,$hrot,$rot,$erot]:
			e.position=Vector2(0,-16)*Floor
		move_and_slide(onlineveloc)
	pass


func _on_Area2D_area_entered(area):
	if "item" in area.name:
		select.append(area)
	pass # Replace with function body.


func _on_Area2D_area_exited(area):
	if "item" in area.name:
		select.erase(area)
		area.selected=false
	pass # Replace with function body.
	
	


func _on_TouchScreenButton_pressed():
	Input.action_press("interact")


func _on_TouchScreenButton_released():
	Input.action_release("interact")
	
func _on_TouchScreenButton2_pressed():
	Input.action_press("item2")


func _on_TouchScreenButton2_released():
	Input.action_release("item2")

func _on_TouchScreenButton3_pressed():
	Input.action_press("item1")


func _on_TouchScreenButton3_released():
	Input.action_release("item1")
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


remotesync func dmg(dmg):
	var label=load("res://scenes/damagemeter.tscn").instance()
	label.get_node("Label").text=str(round(abs(dmg)))
	get_parent().add_child(label)
	label.global_position=global_position
	hp-=dmg
	$Camera2D.position+=Vector2(rand_range(-25,25),rand_range(-25,25))
	if  !gameover and hp<=0 and islocalplayer():
		
		set_process(false)
		$ui.add_child(load("res://gameover.tscn").instance())
		state_machine.stop()
		state_machine.start("death")
		gameover=true
		
	if islocalplayer():$ui/ProgressBar.value=hp
pass # Replace with function body.




func progressbar(delta):
	if islocalplayer():$ui/ProgressBar2.value-=($ui/ProgressBar2.value-$ui/ProgressBar.value)*delta*3




func erot():
	lowestdifference=90
	var found=false
	for e in get_parent().get_children():
		
		if "enemy" in e.name and e.global_position.distance_to(global_position)<1024:
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

master func openchest():
	var chestmap=get_parent().get_node_or_null("chests")
	
	if chestmap!=null:
		var playerpos=chestmap.world_to_map(chestmap.to_local(global_position))
		for e in range(-1,2):
			for i in range(-1,2):
				var tilepos=playerpos+Vector2(e,i)
				if chestmap.get_cellv(tilepos)==0:
					chestmap.set_cellv(tilepos,-1)
					chestmap.rpc("appen",tilepos)
					if round(rand_range(0,1))==1:
						var item=load("res://scenes/onlineitem.tscn").instance()
						item.item="random"
						item.name="item"+str(randi())
						
						get_parent().add_child(item)
						item.global_position=chestmap.to_global(chestmap.map_to_world(tilepos))+Vector2(8,8)
						
						Server.rpc("newitem",item.name,item.item,item.global_position)
					else:
						var path="res://scenes/pizza.tscn"
						var item=load(path).instance()
						item.name="item"+str(randi())
						get_parent().add_child(item)
						
						Server.rpc("uniqueitem",item.name,path,item.global_position)
						item.global_position=chestmap.to_global(chestmap.map_to_world(tilepos))+Vector2(8,8)
						
					for _a in range(rand_range(12,40)):
						Server.rpc("addcoin",chestmap.to_global(chestmap.map_to_world(tilepos))+Vector2(8,8))
					
					
remote func updatepos(pos,rot,FLoor,veloc):
	global_position=pos
	$hrot.rotation=rot
	$rot.rotation=rot
	Floor=FLoor
	onlineveloc=veloc
#	print(rot)

remote func animation(anim,flip):
	if $AnimationPlayer.current_animation!=anim:
		state_machine.travel(anim)
	$Sprite.flip_h=flip


remotesync func small_stuff_add(type,n):
	if islocalplayer():
		Global.small_stuff[type]+=n


remotesync func playsound(sound):
	if islocalplayer():
		add_child(load(sound).instance())

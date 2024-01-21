
extends Area2D
class_name Item
export(String) var item="random"
var selected=false
var in_hitbox=[]
var isgun=false
var guns=["AR"]
var heals=[]
var isheal=false
var healing=20
var cooldown=0.15
var cldn=0
var healingnow=false
var healingtime=1.5
var bullet=load("res://scenes/gunshot.tscn")
var rng=RandomNumberGenerator.new()
var hitbox=[]
var chargetime=3
var charged=false
var rotatable=true

var itemname=["pan","AR","sword"]

var itemtype={
	"pan":"pan.png",
	"sword":"redsword.png",
	"AR":"AR.png",
	"amethyst sword":"amsword.png"
}
var damagedir={
	"pan":5,
	"sword":10,
	"AR":3,
	"amethyst sword":20
}
var damage=0
var id
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
static func get_img(item):
	var itemtype={
	"pan":"pan.png",
	"sword":"redsword.png",
	"AR":"AR.png",
	"amethyst sword":"amsword.png"
	}
	return load("res://"+itemtype[item])

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent().get_node_or_null("MultiPlayerSpawner")!=null:get_parent().get_node("MultiPlayerSpawner").add_node(self)
	rng.randomize()
	if item=="random":
		item=itemname[round(rng.randf_range(0,1))]
	randomize()
	if Server.isserver:
		id=rand_range(0,2000)
		Server.items.append(self)
	
	reload()
	
			
	pass # Replace with function body.

func reload():
	rng.randomize()
	if item=="random":
		item=itemname[rng.randi_range(0,2)]
	$Sprite.texture=load("res://"+itemtype[item])
	isgun=false
	isheal=false
	for e in guns:
		if item==e:
			isgun=true
	for e in heals:
		if item==e:
			isheal=true
		
	if !isheal:
		damage=damagedir[item]
		healing=0
	else:
		healing=damagedir[item]
		damage=0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	owner=get_parent().owner
	process(delta)
	$press_E.visible=selected
	cldn-=delta
	if healingnow:
		healingtime-=delta
	else: healingtime=1.5
	pass
	if get_parent().name=="helditem":
		if not isgun:
			$Particles2D.emitting=Input.is_action_pressed("attack")
			$charged.emitting=charged
			$charged.process_material.trail_divisor=rand_range(30,50)
	else:
		reload()
	
func process(delta):
	pass
func cancel():
	pass
func interact(player):
	
			
	for e in player.items:
		var chcount=e.get_child_count()
		if e.get_child_count()==0:
			get_parent().remove_child(self)
			e.add_child(self)
			position=Vector2.ZERO
			return true
			
	return false
	pass # Replace with function body.

func _on_item_body_exited(body):
	
	if "enemy" in body.name:
		hitbox.erase(body)

func _on_item_body_entered(body):
	
	if body is enemy:
		in_hitbox.append(body)
		hitbox.append(body)

	pass # Replace with function body.


func shot():
	if cldn<=0:
		var player=get_parent().get_parent().get_parent()
		var shot=bullet.instance()
		shot.damage=damage
		shot.velocity=Vector2(10,0).rotated(global_rotation)
		player.get_parent().add_child(shot)
		shot.global_position=global_position
		cldn=cooldown
		
func ability():
	var area=load("res://scenes/dmgarea.tscn").instance()
	var shape=CircleShape2D.new()
	shape.radius=400
	area.shape=shape
	
	get_parent().get_parent().get_parent().get_parent().add_child(area)
	area.global_position=global_position
	
			
	
func calc_knockback(damage,enemy):
	var pos=enemy.global_position-global_position
	pos=pos.normalized()
	return pos*400*damage

func Use():
	
	return use()


func use():
	return false
	pass


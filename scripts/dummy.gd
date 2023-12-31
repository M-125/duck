extends enemy

onready var state_machine = $AnimationTree.get("parameters/playback")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine.start("idle")
	hp=1000
	
func damage(dmg,velocity=Vector2(0,0),nothing=0):
	var label=load("res://scenes/damagemeter.tscn").instance()
	label.get_node("Label").text=str(round(abs(dmg)))
	get_parent().add_child(label)
	label.global_position=global_position
	hp-=abs(dmg)
	Global.addsound("hit")
	if hp<=0:
		queue_free()
	
func _process(e):
	e
func movement():
	"e"
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

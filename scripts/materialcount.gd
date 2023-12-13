tool
extends Control
export(int,"coin","red dye","white dye","wood","amethyst") var type=0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.frame=type
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not Engine.editor_hint:
		$Label.text=str(Global.small_stuff[type])
	pass

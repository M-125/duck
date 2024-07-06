extends map

func _exit_tree():
	var pack=PackedScene.new()
	pack.pack(self)
	ResourceSaver.save("user://house"+Global.house+".tscn",pack)
	ResourceSaver.save("user://saveplayer.tscn",Global.playerpack)
	

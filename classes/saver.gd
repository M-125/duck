extends Resource
class_name Saver
static func save(array,path:String):
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_line(JSON.print(array))
	file.close()

# Load the array
static func load(path):
	var file=File.new()
	file.open(path, File.READ)
	var json_data = file.get_line()
	var loaded_array = JSON.parse(json_data)
	file.close()
	return loaded_array.result

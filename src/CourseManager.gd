extends Node

var occupiedKeys := {}

func _ready():
	var courses = Global.user_data["courses"]
	for index in range(courses.size()):
		var course = courses[index]
		var key = course["key"]
		occupiedKeys[key] = index

func generateUniqueKey():
	var newKey = str(randi() % 1000) # Generates a random number between 0 and 999

	# Check if the generated key is occupied, if so, generate a new one
	while occupiedKeys.has(newKey):
		newKey = str(randi() % 1000)

	return newKey

func isKeyOccupied(key):
	return occupiedKeys.has(key)

func getFreeIndex():
	var courses = Global.user_data["courses"]
	for index in range(courses.size()):
		if !occupiedKeys.has(str(index)): # Check if the index is not occupied
			return index

	# If no free index is found, return -1 (or handle it based on your requirements)
	return -1

func getNewKey():
	var newKey = generateUniqueKey()
	var freeIndex = getFreeIndex()

	if freeIndex != -1:
		# Map the new key with the free index
		occupiedKeys[newKey] = freeIndex
		return newKey
	else:
		return "error"

func removeKey(key):
	if occupiedKeys.has(key):
		var index = occupiedKeys[key]
		occupiedKeys.erase(key) # Remove the key from the dictionary
		return index
	else:
		# Return -1 or handle the case when the key is not found
		return -1

func get_key_index(key:String):
	return occupiedKeys[key]
	

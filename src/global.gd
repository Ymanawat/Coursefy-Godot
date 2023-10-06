extends Node

@onready var control := get_tree().current_scene
@onready var course_container = control.find_child("course_container")
@onready var course_card = preload("res://Scenes/course_card.tscn")
@onready var add_new_course = preload("res://Scenes/add_course.tscn").instantiate()
@onready var add_new_course_details = preload("res://Scenes/add_new_course_details.tscn").instantiate()
@onready var user_data_JSON = ("user://coursefy_user_data.json")
@onready var dashboard = control.find_child("Dashboard_")
@onready var expended_course = control.find_child("course_expended")

var my_course = "res://Firestore/my_course_json.json"
var user_data = {}

func _ready():
	print(user_data_JSON)
	course_container = control.find_child("course_container")
	course_container.add_child(add_new_course)
	user_data = load_json_file(user_data_JSON)
	
	if user_data and user_data.has("courses"):
		# Get the list of courses
		var courses = user_data["courses"]
		
		for course in courses:
			add_course(course["key"], course["course_name"], course["course_description"], course["deadline"], course["total_items"], course["completed_items"])

func create_json(username):
	if !FileAccess.file_exists(user_data_JSON):
		var file = FileAccess.open(user_data_JSON, FileAccess.WRITE)
		var courses = load_json_file(my_course)
		file.store_string(JSON.stringify(courses))
		file.close()
	else:
		user_data["userrname"] = username
		save_json_file()

func reload_courses():
	var add_course_but = course_container.get_child(-1)
	var childrens = course_container.get_children(false)
	for child in childrens:
		if child!=add_course_but:
			child.queue_free()
	if user_data and user_data.has("courses"):
		var courses = user_data["courses"]
		for course in courses:
			add_course(course["key"], course["course_name"], course["course_description"], course["deadline"], course["total_items"], course["completed_items"])
	
func add_course(course_key:String, course_name:String, course_description:String, target:String, total_items:int=0, complete_items:int=0):
	var new_course = course_card.instantiate()
	new_course.key = course_key
	new_course.course_name_text = course_name
	new_course.course_description_text = course_description
	new_course.course_deadline_text = target
	new_course.total_tasks = total_items
	new_course.done_tasks = complete_items
	course_container.add_child(new_course)
	add_child_new_course_button()
	
func append_courses(course_name:String, course_description:String, target:String, total_items:int=0, completed_items:int=0):
	var newkey = CourseManager.getNewKey()
	add_course(newkey, course_name, course_description, target, total_items, completed_items)
	var newCourse = {
		"key": newkey,
		"course_name": course_name,
		"course_description": course_description,
		"total_items": total_items,
		"completed_items": completed_items,
		"deadline" : target,
		"completed": false,
		"items": []
	}
	user_data["courses"].append(newCourse)
	# Save the updated user_data dictionary to the JSON file
	save_json_file()
	
func remove_course(idx:int):
	user_data["courses"].remove_at(idx)
#	print(user_data["courses"][idx])
	save_json_file()
	
	for childs in course_container.get_children():
		course_container.remove_child(childs)

	if user_data.has("courses"):
		# Get the list of courses
		var courses = user_data["courses"]
		
		for course in courses:
			add_course(course["key"], course["course_name"], course["course_description"], course["deadline"], course["total_items"], course["completed_items"])
	add_child_new_course_button()

func add_child_new_course_button():
	# Remove the node from its current parent
	if add_new_course.get_parent():
		add_new_course.get_parent().remove_child(add_new_course)
	course_container.add_child(add_new_course)
	course_container.remove_child(add_new_course_details)

func add_child_new_course_form():
	# Remove the node from its current parent
	if add_new_course_details.get_parent():
		add_new_course_details.get_parent().remove_child(add_new_course_details)
	course_container.add_child(add_new_course_details)
	course_container.remove_child(add_new_course)

func expand_card(x:int):
	dashboard.hide()
	control.expand_card(x)
	
func collapse_expended_card():
	control.hide_expended()
	dashboard.show()

func load_json_file(path : String):
	if FileAccess.file_exists(path):
		var data_file = FileAccess.open(path, FileAccess.READ)
		var parsed_data = JSON.parse_string(data_file.get_as_text())
		
		if parsed_data is Dictionary:
			return parsed_data
		else:
			printerr("Error reading JSON file")
	else:
		printerr("JSON file doesn't exist")

func save_json_file():
	if FileAccess.file_exists(user_data_JSON):
		var file = FileAccess.open(user_data_JSON, FileAccess.WRITE)
		var json_text = JSON.stringify(user_data)
		
		file.store_string(json_text)
		file.close()
		print("Data saved successfully!")
	else:
		printerr("Error saving JSON file")

func reload_json_data():
	# Reload JSON data and update the UI
	user_data = load_json_file(user_data_JSON)
	course_container.queue_free()  # Remove all existing course cards from the container
	if user_data.has("courses"):
		# Get the list of courses
		var courses = user_data["courses"]
		for course in courses:
			add_course(course["key"], course["course_name"], course["course_description"], course["deadline"], course["total_items"], course["completed_items"])


#########################
#web based logic
#
#func save_json_locally(data):
#	# Convert data to JSON string
#	var json_data = JSON.stringify(data)
#
#	# Save the JSON data in the browser's localStorage (for web)
#	if OS.get_name() == "HTML5":
#		var path = OS.get_cache_dir()
#		save_json_file(json_data, )
#		print("Data saved locally!")
#	# Save the JSON data in a local file (for non-web platforms)
#	else:
#		save_json_file(data, user_data_JSON)
#		print("Data saved to file!")
#
#func load_json_locally():
#	# Load the JSON data from the browser's localStorage (for web)
#	if OS.get_name() == "HTML5":
#		var json_data = Browser.local_storage_get_item("user_data")
#		if json_data:
#			var parsed_data = JSON.parse(json_data)
#			if parsed_data is Dictionary:
#				user_data = parsed_data
#				reload_json_data()
#				print("Data loaded from local storage!")
#			else:
#				printerr("Error parsing JSON data from local storage")
#		else:
#			print("No JSON data found in local storage.")
#	# Load the JSON data from a local file (for non-web platforms)
#	else:
#		user_data = load_json_file(user_data_JSON)
#		if user_data:
#			reload_json_data()
#			print("Data loaded from file!")

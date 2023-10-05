extends Node

@onready var control := get_tree().current_scene
@onready var course_container = control.find_child("course_container")
@onready var course_card = preload("res://Scenes/course_card.tscn")
@onready var add_new_course = preload("res://Scenes/add_course.tscn").instantiate()
@onready var add_new_course_details = preload("res://Scenes/add_new_course_details.tscn").instantiate()
@onready var user_data_JSON = ("res://Firestore/user_data.json")
@onready var dashboard = control.find_child("Dashboard_")
@onready var expended_course = control.find_child("course_expended")
var user_data = {}

func _ready():
	course_container.add_child(add_new_course)
	user_data = load_json_file(user_data_JSON)
	
	if user_data.has("courses"):
		# Get the list of courses
		var courses = user_data["courses"]
		
		for course in courses:
			add_course(course["course_name"],course["course_description"], course["deadline"], course["total_items"], course["completed_items"])

func add_course(course_name:String, course_description:String, target:String, total_items:int=0, complete_items:int=0):
	var new_course = course_card.instantiate()
	new_course.course_name_text = course_name
	new_course.course_description_text = course_description
	new_course.course_deadline_text = target
	new_course.total_tasks = total_items
	new_course.done_tasks = complete_items
	course_container.add_child(new_course)
	add_child_new_course_button()
	
func append_courses(course_name:String, course_description:String, target:String, total_items:int=0, completed_items:int=0):
	add_course(course_name, course_description, target, total_items, completed_items)
	var newCourse = {
		"key": CourseManager.getNewKey(),
		"course_name": course_name,
		"total_items": total_items,
		"completed_items": completed_items,
		"completed": false,
		"items": []
	}
	user_data["courses"].append(newCourse)
	# Save the updated user_data dictionary to the JSON file
	save_json_file(user_data, user_data_JSON)

func add_child_new_course_button():
	# Remove the node from its current parent
	if add_new_course.get_parent():
		add_new_course.get_parent().remove_child(add_new_course)
	course_container.remove_child(add_new_course_details)
	course_container.add_child(add_new_course)

func add_child_new_course_form():
	# Remove the node from its current parent
	if add_new_course_details.get_parent():
		add_new_course_details.get_parent().remove_child(add_new_course_details)
	course_container.remove_child(add_new_course)
	course_container.add_child(add_new_course_details)

func expand_card(x:int):
	expended_course.show()
	expended_course.setup_course(x)
	dashboard.hide()
	
func collapse_expended_card():
	expended_course.hide()
	expended_course.clear()
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

func save_json_file(data, path):
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.WRITE)
		file.store_string(user_data.get_as_text())
		file.close()
		print("Data saved successfully!")
	else:
		printerr("Error saving JSON file")



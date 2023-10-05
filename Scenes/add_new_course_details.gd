extends Button

func _ready():
	pass

func _on_done_button_pressed():
	var course_name = $MarginContainer/VBoxContainer/course_title.get_line(0)
	
	if course_name == "":
		return
	
	var course_description = $MarginContainer/VBoxContainer/course_description.get_line(0)
	var target_date = $MarginContainer/VBoxContainer/target_date.get_line(0)
	
	$MarginContainer/VBoxContainer/course_title.clear()
	$MarginContainer/VBoxContainer/course_description.clear()
	$MarginContainer/VBoxContainer/target_date.clear()
	Global.append_courses(course_name, course_description, target_date)

func _on_cancel_button_pressed():
	Global.add_child_new_course_button()

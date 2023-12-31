extends MarginContainer

var course_name:Label
var course_description:Label
var course_name_edit:TextEdit
var course_description_edit:TextEdit
var progress:Label
var time_to_complete:Label
var edit_button:Button
var delete_button:Button
var done_button:Button
var course_labels: VBoxContainer
var course_edit: VBoxContainer
var panel_separator: Panel
var progress_bar:ProgressBar
var total_tasks_label:Label
var total_task_container
var deadline_edit:TextEdit
var below_bar
var edit:bool = 0

var key = ""
var course_name_text = ""
var course_description_text = ""
var course_deadline_text = ""
var total_tasks = 0
var done_tasks = 0
var current_size
var min_size = Vector2(300,200)

func _ready():
	course_labels = $MarginContainer/VBoxContainer/HBoxContainer/course_labels
	course_edit = $MarginContainer/VBoxContainer/HBoxContainer/course_edit
	course_name = $MarginContainer/VBoxContainer/HBoxContainer/course_labels/course_name
	course_description= $MarginContainer/VBoxContainer/HBoxContainer/course_labels/course_description
	course_name_edit = $MarginContainer/VBoxContainer/HBoxContainer/course_edit/course_name_edit
	course_description_edit = $MarginContainer/VBoxContainer/HBoxContainer/course_edit/course_description_edit
	progress = $MarginContainer/VBoxContainer/VBoxContainer2/HBoxContainer/progress_percentage
	time_to_complete = $MarginContainer/VBoxContainer/VBoxContainer2/HBoxContainer/time_to_complete
	edit_button = $MarginContainer/VBoxContainer/HBoxContainer/edit_button
	delete_button= $MarginContainer/VBoxContainer/HBoxContainer/delete_button
	done_button = $MarginContainer/VBoxContainer/HBoxContainer/done_button
	panel_separator = $MarginContainer/VBoxContainer/HBoxContainer/panel_separator
	progress_bar = $MarginContainer/VBoxContainer/VBoxContainer2/ProgressBar
	total_task_container = $MarginContainer/VBoxContainer/MarginContainer
	total_tasks_label = $MarginContainer/VBoxContainer/MarginContainer/MarginContainer/total_tasks
	deadline_edit=$MarginContainer/VBoxContainer/HBoxContainer/course_edit/deadline_edit
	
	below_bar = $MarginContainer/VBoxContainer/VBoxContainer2
	set_key(key)
	set_course_name(course_name_text)
	set_course_description(course_description_text)
	set_deadline(course_deadline_text)
	set_total_tasks(total_tasks)
	set_done_tasks(done_tasks)
	set_progress()
	normal_mode()

	
func _process(delta):
	var mouse_position = get_global_mouse_position()
	var rect = get_global_rect()
	if rect.has_point(mouse_position):
		mouse_entered()
	else:
		mouse_exited()


func normal_mode():
	custom_minimum_size = min_size
	total_task_container.show()
	edit_button.hide()
	delete_button.hide()
	done_button.hide()
	course_edit.hide()
	course_labels.show()
	panel_separator.show()
	below_bar.show()
	
	current_size = size
	
func edit_mode():
	total_task_container.hide()
	panel_separator.hide()
	edit_button.hide()
	delete_button.hide()
	done_button.show()
	course_edit.show()
	course_labels.hide()
	below_bar.hide()
	
	course_name_edit.text = course_name_text
	course_description_edit.text = course_description_text
	deadline_edit.text = course_deadline_text
	
	custom_minimum_size = current_size

func hover_mode():
	edit_button.show()
	delete_button.show()
	done_button.hide()

func _on_edit_pressed():
	edit = 1
	edit_mode()

func _on_delete_pressed():
	Global.remove_course(CourseManager.get_key_index(key))
	queue_free()

func _on_done_pressed():
	edit = 0
	set_text()

func set_key(s:String):
	key = s

func set_text():
	if course_name_edit.get_line(0) != "":
		set_course_name(course_name_edit.get_line(0))
		course_name_edit.clear()
	if course_description_edit.get_line(0) != "":
		set_course_description(course_description_edit.get_line(0))
		course_description_edit.clear()
	if deadline_edit.get_line(0)!= "":
		set_deadline(deadline_edit.get_line(0))
	edit = 0
	normal_mode()

func set_course_name(x:String):
	course_name.text = x

func set_course_description(x:String):
	course_description.text = x

func set_progress():
	var progress_percantage
	if total_tasks:
		progress_percantage = (float(done_tasks)/float(total_tasks))*100
	else:
		progress_percantage = 0
	progress.text = str(int(progress_percantage))
	progress_bar.value = (progress_percantage)
	
func set_deadline(x:String):
	time_to_complete.text = x
	
func set_total_tasks(x:int):
	total_tasks = x
	total_tasks_label.text = str(x) + " tasks"
	set_progress()

func set_done_tasks(x):
	done_tasks = x
	set_progress()

func mouse_entered():
	if (!edit):
		hover_mode()

func mouse_exited():
	if(!edit):
		normal_mode()

func _on_text_edit_gui_input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_accept"):
			set_text()

		if event.is_action_pressed("tab"):
			print("pressed")
			var current_focus
			
			for edits in course_edit.get_children():
				if edits.has_focus():
					current_focus = edits
			
			var next_edit = null

			# Find the next TextEdit node based on the currently focused control
			if current_focus is TextEdit:
				next_edit = current_focus.find_next_valid_focus()
				next_edit.grab_focus()
			else:
				next_edit = course_name_edit # Set the first TextEdit node in your scene hierarchy

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_mouse"):
			Global.expand_card(CourseManager.get_key_index(key))
			

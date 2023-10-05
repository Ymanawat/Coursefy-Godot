extends MarginContainer

var course_card = find_child("course_card")
var list_item = preload("res://Scenes/list_item.tscn")
var add_items_buttom = preload("res://Scenes/add_new_list_item.tscn").instantiate()
var idx = 0

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
var item_form = preload("res://Scenes/add_item_form.tscn").instantiate()
var edit:bool = 0
var container

var key = ""
var course_name_text = ""
var course_description_text = ""
var course_deadline_text = ""
var total_tasks = 0
var done_tasks = 0

func _ready():
	container = $VBoxContainer
	course_card = $VBoxContainer/course_card
	course_labels = $VBoxContainer/course_card/MarginContainer/VBoxContainer/HBoxContainer/course_labels
	course_edit = $VBoxContainer/course_card/MarginContainer/VBoxContainer/HBoxContainer/course_edit
	course_name = $VBoxContainer/course_card/MarginContainer/VBoxContainer/HBoxContainer/course_labels/course_name
	course_description= $VBoxContainer/course_card/MarginContainer/VBoxContainer/HBoxContainer/course_labels/course_description
	course_name_edit = $VBoxContainer/course_card/MarginContainer/VBoxContainer/HBoxContainer/course_edit/course_name_edit
	course_description_edit = $VBoxContainer/course_card/MarginContainer/VBoxContainer/HBoxContainer/course_edit/course_description_edit
	progress = $VBoxContainer/course_card/MarginContainer/VBoxContainer/VBoxContainer2/HBoxContainer/progress_percentage
	time_to_complete = $VBoxContainer/course_card/MarginContainer/VBoxContainer/VBoxContainer2/HBoxContainer/time_to_complete
	edit_button = $VBoxContainer/course_card/MarginContainer/VBoxContainer/HBoxContainer/edit_button
	delete_button= $VBoxContainer/course_card/MarginContainer/VBoxContainer/HBoxContainer/delete_button
	done_button = $VBoxContainer/course_card/MarginContainer/VBoxContainer/HBoxContainer/done_button
	panel_separator = $VBoxContainer/course_card/MarginContainer/VBoxContainer/HBoxContainer/panel_separator
	progress_bar = $VBoxContainer/course_card/MarginContainer/VBoxContainer/VBoxContainer2/ProgressBar
	total_tasks_label = $VBoxContainer/course_card/MarginContainer/VBoxContainer/MarginContainer/MarginContainer/total_tasks
	set_key(key)
	set_course_name(course_name_text)
	set_course_description(course_description_text)
	set_deadline(course_deadline_text)
	set_total_tasks(total_tasks)
	set_done_tasks(done_tasks)
	set_progress()
	normal_mode()
	setup_course(idx)
	container.add_child(add_items_buttom)

func _on_button_pressed():
	Global.collapse_expended_card()
	
func setup_course(idx:int):
	var course = Global.user_data["courses"][idx]
	if course:
		set_key(course["key"])
		set_course_name(course["course_name"])
		set_course_description(course["course_description"])
		set_deadline(course["deadline"])
		set_total_tasks(course["total_items"])
		set_done_tasks(course["completed_items"])
		
		for item in course["items"]:
#			if item["type"] == "link":
			var new_item = list_item.instantiate()
			new_item.key = item["key"]
			new_item.item_name = item["title"]
			new_item.item_link = item["url"]
			new_item.completed = item["completed"]
			container.add_child(new_item)

func show_add_items_form():
	add_items_buttom.get_parent().remove_child(add_items_buttom)
	container.add_child(item_form)
	
func show_add_item_button():
	item_form.get_parent().remove_child(item_form)
	container.add_child(add_items_buttom)

func append_items(link):
	var idx = CourseManager.get_key_index(key)
	var items = Global.user_data["courses"][idx]["items"]
	var new_key = CourseManager.getNewItemKey()
	var new_item = list_item.instantiate()
	new_item.key = new_key
	MetadataRequest.url=link
	new_item.item_name = "name"
	new_item.item_link = link
	
	container.add_child(new_item)
	
	var new_item_data = {
		"key" : new_key,
		"title" : name,
		"url" : link,
		"completed" : 0
	}
	items.append(new_item_data)
	total_tasks+=1
	update_item_json()
	show_add_item_button()

func remove_item(key):
	var items = Global.user_data["courses"][idx]["items"]
	var index = CourseManager.getItemKeyIndex(key, idx)
	items.remove_at(index)
	Global.save_json_file()

func _process(delta):
	var mouse_position = get_global_mouse_position()
	var rect = get_global_rect()
	if rect.has_point(mouse_position):
		mouse_entered()
	else:
		mouse_exited()


func normal_mode():
	edit_button.hide()
	delete_button.hide()
	done_button.hide()
	course_edit.hide()
	course_labels.show()
	panel_separator.show()
	
func edit_mode():
	edit_button.hide()
	delete_button.hide()
	done_button.show()
	course_edit.show()
	course_labels.hide()
	panel_separator.hide()

func hover_mode():
	edit_button.show()
	delete_button.show()
	done_button.hide()

func _on_edit_pressed():
	edit = 1
	edit_mode()

func _on_delete_pressed():
	Global.collapse_expended_card()
	Global.remove_course(CourseManager.get_key_index(key))

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
	edit = 0
	update_item_json()
	normal_mode()

func set_course_name(x:String):
	course_name_text = x
	course_name.text = x

func set_course_description(x:String):
	course_description_text = x
	course_description.text = x

func set_progress():
	var progress_percantage = 100
	if total_tasks>0:
		print(float(done_tasks)/float(total_tasks))
		progress_percantage = (float(done_tasks)/float(total_tasks))*100.0
	else:
		progress_percantage = 0
	progress.text = str(progress_percantage)
	progress_bar.value = progress_percantage
	
func set_deadline(x:String):
	course_deadline_text = x
	time_to_complete.text = x

func set_total_tasks(x:int):
	total_tasks = x
	total_tasks_label.text = str(x) + " tasks"

func set_done_tasks(x:int):
	done_tasks=x
	set_progress()

func update_done_tasks(x:int):
	done_tasks+=x
	update_item_json()
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

func update_item_json():
	var index = CourseManager.get_key_index(key)
	var items = Global.user_data["courses"][index]["items"]
	var course = {
		"key": key,
		"course_name" : course_name_text,
		"course_description" : course_description_text,
		"total_items" : total_tasks,
		"completed_items" : done_tasks,
		"deadline": course_deadline_text,
		"items" : items
	}
	Global.user_data["courses"][index] = course
	Global.save_json_file()

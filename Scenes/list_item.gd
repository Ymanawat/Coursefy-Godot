extends MarginContainer
var http_request:HTTPRequest
@onready var white_panel_theme = preload("res://Scenes/white_panel.tres")
@onready var yellow_panel_theme = preload("res://Scenes/Course_Card_panel.tres")
var item_edit_box = find_child("item_edit")
var item_label_box = find_child("item_label")
var edit_button:Button
var delete_button:Button
var done_button:Button
var check_button:CheckBox
var item_name_edit:TextEdit
var item_link_edit:TextEdit
var item_name_label:Label
var panel_separator:Panel
var link_icon:TextureRect
var edit = 0

var key = ""
var index = ""
var item_name = ""
var item_link = ""
var completed = 0

var prev_link = ""
var fetched_title=""

func _ready():
	http_request = $HTTPRequest
	item_edit_box = $MarginContainer/HBoxContainer/item_edit
	item_label_box = $MarginContainer/HBoxContainer/item_label
	item_name_edit = $MarginContainer/HBoxContainer/item_edit/item_name_edit
	item_link_edit = $MarginContainer/HBoxContainer/item_edit/item_link_edit
	item_name_label = $MarginContainer/HBoxContainer/item_label/item_name
	edit_button = $MarginContainer/HBoxContainer/edit_button
	delete_button = $MarginContainer/HBoxContainer/delete_button
	done_button = $MarginContainer/HBoxContainer/done_button
	check_button = $MarginContainer/HBoxContainer/CheckButton
	panel_separator = $MarginContainer/HBoxContainer/panel_separator
	link_icon = $MarginContainer/HBoxContainer/link_icon
	normal_mode()
	set_item_name(item_name)
	set_item_link_text(item_link)
	set_toggle(completed)

func _process(delta):
	var mouse_position = get_global_mouse_position()
	var rect = get_global_rect()
	if rect.has_point(mouse_position):
		mouse_entered()
	else:
		mouse_exited()

func mouse_entered():
	if (!edit):
		hover_mode()

func mouse_exited():
	if(!edit):
		normal_mode()

func normal_mode():
	edit_button.hide()
	delete_button.hide()
	item_edit_box.hide()
	item_label_box.show()
	panel_separator.show()
	done_button.hide()
	check_button.show()
	link_icon.show()
	
func edit_mode():
	edit_button.hide()
	delete_button.hide()
	done_button.show()
	item_edit_box.show()
	item_name_edit.text = item_name
	item_link_edit.text = item_link
	item_label_box.hide()
	panel_separator.hide()
	check_button.hide()
	link_icon.hide()

func hover_mode():
	edit_button.show()
	delete_button.show()

func _on_edit_pressed():
	edit = 1
	edit_mode()

func _on_delete_pressed():
	get_parent().get_parent().remove_item(key)
	queue_free()

func _on_done_pressed():
	edit = 0
	set_text()

func set_item_name(x: String):
	item_name = x
	item_name_label.text = x
	if item_name=="":
		set_item_link(item_link)
	else:
		update_item_json()

func set_item_link_text(x: String):
	item_link = x

func set_item_link(x: String):
	if item_name=="" or prev_link != x:
		await request_title(x)
		item_link = x
		prev_link = x

func set_text():
	if item_name_edit.get_line(0) != "":
		set_item_name(item_name_edit.get_line(0))
		item_name_edit.clear()
	if item_link_edit.get_line(0) != "":
		set_item_link(item_link_edit.get_line(0))
		item_link_edit.clear()
	edit = 0
	update_item_json()
	normal_mode()

func set_toggle(completed):
	if completed:
		check_button.set_pressed_no_signal(true)
		$white_panel.hide()
		$yellow_panel.show()
	else:
		check_button.set_pressed_no_signal(false)
		$white_panel.show()
		$yellow_panel.hide()

func _on_check_button_toggled(button_pressed):
	if button_pressed:
		completed = 1
		check_button.button_pressed = true
		$white_panel.hide()
		$yellow_panel.show()
		get_parent().get_parent().update_done_tasks(1)
	else:
		completed = 0
		check_button.button_pressed = false
		$white_panel.show()
		$yellow_panel.hide()
		get_parent().get_parent().update_done_tasks(-1)
	update_item_json()

func update_item_json():
	var item = {
		"key": key,
		"title" : item_name,
		"url" : item_link,
		"completed" : completed
	}
	var course_idx = get_parent().get_parent().idx
	var index = CourseManager.getItemKeyIndex(key, course_idx)
	Global.user_data["courses"][course_idx]["items"][index] = item
	Global.save_json_file()

func open_link_in_browser():
	if item_link!="":
		OS.shell_open(item_link)
		
func _on_gui_input(event):
	if event is InputEventAction:
		if event.is_action_pressed("ui_accept"):
			set_text()
	
	if event is InputEventMouseButton and !edit:
		if event.is_action_pressed("left_mouse"):
				open_link_in_browser()

func request_title(url):
	print("requested")
	http_request.request(url)

func _on_request_completed(result, response_code, headers, body):
	print("called request completed")
	if response_code == 200:
		var body_text = body.get_string_from_utf8()
		
		# Find the index of the opening <title> tag including attributes
		var title_start = body_text.find("<title")
		
		if title_start >= 0:
			# Find the index of the closing > after the opening <title> tag
			title_start = body_text.find(">", title_start)
			
			if title_start >= 0:
				# Increment title_start to exclude the > character
				title_start += 1
				
				# Find the index of the closing </title> tag
				var title_end = body_text.find("</title>", title_start)
				
				if title_end >= 0:
					# Extract the content between <title> and </title> tags
					var title_content = body_text.substr(title_start, title_end - title_start)
					set_item_name(title_content.strip_edges())
				else:
					print("Closing </title> tag not found in the webpage.")
			else:
				print("Closing > character after <title not found in the webpage.")
		else:
			print("Opening <title tag not found in the webpage.")
	else:
		print("Failed to fetch the webpage. Response code:", response_code)


func _on_item_name_edit_gui_input(event):
	if event is InputEvent:
		if event.is_action_pressed("ui_accept"):
			_on_done_pressed()

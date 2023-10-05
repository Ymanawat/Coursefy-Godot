extends MarginContainer

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

var edit = 0

var key = ""
var index = ""
var item_name = ""
var item_link = ""
var completed = 0

func _ready():
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
	
	normal_mode()
	set_item_name(item_name)
	set_item_link(item_link)
	_on_check_button_toggled(completed)

func _process(delta):
	var mouse_position = get_global_mouse_position()
	var rect = get_global_rect()
	if rect.has_point(mouse_position):
		mouse_entered()
	else:
		mouse_exited()

func _on_text_edit_gui_input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_accept"):
			set_text()

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
	
func edit_mode():
	edit_button.hide()
	delete_button.hide()
	done_button.show()
	item_edit_box.show()
	item_label_box.hide()
	panel_separator.hide()
	check_button.hide()

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
	
func set_item_link(x: String):
	item_link = x

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

func _on_check_button_toggled(button_pressed):
	if button_pressed:
		completed = 1
		check_button.button_pressed = true
		$white_panel.hide()
		$yellow_panel.show()
		get_parent().get_parent().update_completed_tasks(1)
	else:
		completed = 0
		check_button.button_pressed = false
		$white_panel.show()
		$yellow_panel.hide()
		get_parent().get_parent().update_completed_tasks(-1)
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

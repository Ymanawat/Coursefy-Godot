extends MarginContainer

@onready var white_panel_theme = preload("res://Scenes/white_panel.tres")
@onready var yellow_panel_theme = preload("res://Scenes/Course_Card_panel.tres")
var item_edit_box = find_child("item_edit")
var item_label_box = find_child("item_label")
var edit_button:Button
var delete_button:Button
var check_button:CheckBox
var item_name_edit:TextEdit
var item_link_edit:TextEdit
var item_name_label:Label
var panel_separator:Panel

var edit = 0

var key = ""
var item_name = ""
var item_link = ""

func _ready():
	item_edit_box = find_child("item_edit")
	item_label_box = find_child("item_label")
	item_name_edit = $MarginContainer/HBoxContainer/item_edit/item_name_edit
	item_link_edit = $MarginContainer/HBoxContainer/item_edit/item_link_edit
	item_name_label = $MarginContainer/HBoxContainer/item_label/item_name
	edit_button = $MarginContainer/HBoxContainer/edit_button
	delete_button = $MarginContainer/HBoxContainer/delete_button
	check_button = $MarginContainer/HBoxContainer/CheckButton
	panel_separator = $MarginContainer/HBoxContainer/panel_separator

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
	
func edit_mode():
	edit_button.hide()
	delete_button.hide()
	item_edit_box.show()
	item_label_box.hide()
	panel_separator.hide()

func hover_mode():
	edit_button.show()
	delete_button.show()

func _on_edit_pressed():
	edit = 1
	edit_mode()

func _on_delete_pressed():
	queue_free()

func _on_done_pressed():
	edit = 0
	set_text()

func set_item_name(x: String):
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
	normal_mode()

func _on_check_button_toggled(button_pressed):
	if button_pressed:
		$white_panel.hide()
		$yellow_panel.show()
	else:
		$white_panel.show()
		$yellow_panel.hide()

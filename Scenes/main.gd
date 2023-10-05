extends Control

var user_name:Label
var motivation_lines:Label
var expended_course = preload("res://Scenes/Course_expended.tscn")
var expended_view

func _ready():
	var viewport_height = get_viewport_rect().size.y
	$MarginContainer/VBoxContainer/ScrollContainer.custom_minimum_size.y = viewport_height-160

func expand_card(x:int):
	$MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/Dashboard_.hide()
	expended_view = expended_course.instantiate()
	expended_view.idx = x
	$MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer.add_child(expended_view)

func hide_expended():
	$MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer.remove_child(expended_view)
	expended_view.queue_free()


func _on_resized():
	var viewport_height = get_viewport_rect().size.y
	$MarginContainer/VBoxContainer/ScrollContainer.custom_minimum_size.y = viewport_height-160

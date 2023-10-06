extends Control

var user_name_label:Label
var motivation_label:Label
var expended_course = preload("res://Scenes/Course_expended.tscn")
var expended_view
var first_access_screen
var user_name_edit
var username = ""

var messages := [
	"Learn. Believe. Create.",
	"Knowledge for Progress, Learning for Life.",
	"Maximize Your Productivity, Minimize Your Effort.",
	"Learn More, Achieve More.",
	"Fuel Your Progress, follow structured courses",
	"Strive for Progress, Not Perfection.",
	"Master Your Craft, Master Your Time.",
	"Small Steps, Big Results.",
	"Simple Learning, Significant Results.",
	"Knowledge Grows, Productivity Shows."
]

func _ready():
	first_access_screen = $first_access
	user_name_edit = $first_access/Panel2/MarginContainer/VBoxContainer/TextEdit
	motivation_label = find_child("motivation")
	set_motivation_lines()
	user_name_label = find_child("username")
	if Global.user_data:
		if Global.user_data.has("username"):
			first_access_screen.hide()
			username = Global.user_data["username"]
		else:
			first_access_screen.show()
		user_name_label.text = username
		
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

func _on_get_started_button_pressed():
	username = user_name_edit.get_line(0)
	user_name_label.text = username
	Global.create_json(username)
	first_access_screen.hide()

func set_motivation_lines():
	motivation_label.text = messages[randi() % 10]

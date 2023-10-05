extends Button

func _ready():
	self.pressed.connect(on_add_pressed)

func on_add_pressed():
	Global.add_child_new_course_form()

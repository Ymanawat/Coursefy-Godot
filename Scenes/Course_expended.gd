extends Control

var data = Global.user_data

func _ready():
	pass

func _process(delta):
	pass

func _on_button_pressed():
	Global.collapse_expended_card()

#func setup_course(key:int):
#	if data["courses"][str(key)]:
		

extends HBoxContainer

func _ready():
	$Add_new_item.pressed.connect(on_add_pressed)

func on_add_pressed():
	get_parent().get_parent().show_add_items_form()

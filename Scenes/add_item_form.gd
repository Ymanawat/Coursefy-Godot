extends MarginContainer

var item_link_edit
var item_link_text

func _ready():
	item_link_edit = $MarginContainer/HBoxContainer/itemLink

func _on_add_new_item_pressed():
	item_link_text = item_link_edit.get_line(0)
	get_parent().get_parent().append_items(item_link_text)
	item_link_edit.clear()

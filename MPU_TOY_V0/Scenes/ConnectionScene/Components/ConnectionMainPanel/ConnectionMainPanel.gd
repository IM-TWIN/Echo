extends TextureRect

export(NodePath) var popup_confirm_connection_nodepath
export(NodePath) var devicelist_nodepath
export(NodePath) var connection_timer_nodepath
export(NodePath) var loading_animation_nodepath
export(NodePath) var popup_connection_failed_nodepath
export(Resource) var device_item_template
export(NodePath) var file_management_panel_path

var popup_confirm_connection
var devicelist
var connection_timer
var loading_animation
var popup_connection_failed
var file_management_panel

signal connection_request(address)
signal connection_confirmed()
signal connection_aborted()

# Called when the node enters the scene tree for the first time.
func _ready():
	popup_confirm_connection = get_node(popup_confirm_connection_nodepath)
	devicelist = get_node(devicelist_nodepath)
	connection_timer = get_node(connection_timer_nodepath)
	loading_animation = get_node(loading_animation_nodepath)
	popup_connection_failed = get_node(popup_connection_failed_nodepath)
	file_management_panel = get_node(file_management_panel_path)

func add_device_item(name, address):
	var device_item = device_item_template.instance()

	# fill the new device item with the name and address of the new device found
	if(name == ""):
		device_item.get_node("Device/Name").set_text("N/A")
	else:
		device_item.get_node("Device/Name").set_text(name)
	device_item.get_node("Device/Address").set_text(address)

	# Connects the pressed signal of the Connect button to the _on_connect function
	device_item.get_node("Connect").connect("pressed", self, "_on_connect_button_pressed", [address])

	# adds the new device item to the device list
	devicelist.add_child(device_item)
	
	# adds  separator
	var h_line = HSeparator.new()
	devicelist.add_child(h_line)


func show_connection_confirmation():
	loading_animation.hide()
	connection_timer.stop()
	popup_confirm_connection.show()
	pass
	
func _on_connect_button_pressed(dev_address):
	loading_animation.show()
	connection_timer.start()
	emit_signal("connection_request",dev_address)


func _on_ConnectionTimer_timeout():
	popup_connection_failed.show()


# return from connection failed message
func _on_Return_pressed():
	popup_connection_failed.hide()
	loading_animation.hide()
	pass # Replace with function body.


func _on_AbortConnection_pressed():
	popup_confirm_connection.hide()
	emit_signal("connection_aborted")


func _on_ConnectionConfirmation_pressed():
	popup_confirm_connection.hide()
	emit_signal("connection_confirmed")


func _on_Files_pressed():
	file_management_panel.show()
	pass # Replace with function body.

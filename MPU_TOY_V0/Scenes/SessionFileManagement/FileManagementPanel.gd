extends Panel

export(Resource) var file_item

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var file_to_delete_path=""

signal delete_log_file()

#-------------------------------------------------------------------------------------------------
func _ready():
	pass # Replace with function body.


#-------------------------------------------------------------------------------------------------
func show():
	visible = true
	update_file_list()


#-------------------------------------------------------------------------------------------------
func update_file_list():
	for child in $Container/FileList/Items.get_children():
		child.queue_free()
	
	var dir = Directory.new()

	dir.open(OS.get_user_data_dir())
	
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			print(" file- "+file)
			var new_file_item = file_item.instance()
			new_file_item.find_node("Filename").text = file
			new_file_item.find_node("ShareButton").connect("button_down",self,"share_file",[file])
			new_file_item.find_node("DeleteButton").connect("button_down",self,"delete_file",[file])
			$Container/FileList/Items.add_child(new_file_item)
	dir.list_dir_end()

#-------------------------------------------------------------------------------------------------
func confirm():
	var dir = Directory.new()
	dir.remove(file_to_delete_path)
	update_file_list()
	pass

#-------------------------------------------------------------------------------------------------
func delete_file(filename):
	print("[FileManagementPanel.gd][delete_file]...")
	file_to_delete_path = OS.get_user_data_dir() + "/"+filename
	
	#questo segnale è captato da Lokahi;ainScene.gd
	emit_signal("delete_log_file")
	print ("deleting file:"+filename)
	#print ("file path:"+ file_to_delete_path)
	
	#VALERIO: questo mi fa cancellare direttamente il file, senza chiedere
	#conferma traite la finestra di dialogo popup
	#confirm()
	pass

#-------------------------------------------------------------------------------------------------
func share_file(filename):
#		var file_save_path = OS.get_user_data_dir() + "/"+filename
#		BleManager.ble.shareTextFile(file_save_path,"Log File", "Log File", "Log file of the PlusMe device")	
			# initialize the share singleton if it exists
	if Engine.has_singleton("GodotShare"):
		var share = Engine.get_singleton("GodotShare")
		var file_save_path = OS.get_user_data_dir() + "/"+filename
		share.shareTextFile(file_save_path,"Log File", "Log File", "Log file of the PlusMe device")	

#-------------------------------------------------------------------------------------------------
func _on_Files_button_down():
	show()
	pass # Replace with function body.


#-------------------------------------------------------------------------------------------------
func _on_CloseButton_button_down():
	visible = false	
	pass # Replace with function body.

#-------------------------------------------------------------------------------------------------


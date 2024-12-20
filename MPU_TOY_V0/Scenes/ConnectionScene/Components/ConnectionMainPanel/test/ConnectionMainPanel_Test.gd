extends Node

export(NodePath) var MainPanel_nodepath
export(Resource) var DeviceListItem

var MainPanel

# Called when the node enters the scene tree for the first time.
func _ready():
	MainPanel = get_node(MainPanel_nodepath)
	MainPanel.connect("connection_request", self, "_on_connection_request")
	MainPanel.connect("connection_confirmed", self, "_on_connection_confirmed")
	MainPanel.connect("connection_aborted", self, "_on_connection_aborted")	
	pass # Replace with function body.


func _on_Scan_pressed():
	for i in range(1,20):
		MainPanel.add_device_item("Device"+str(i),"wer:wer:Wer:"+str(i))


func _on_connection_request(address):
	$ConnectionTime.start()
	print(" lighting up device with address :"+address)


func _on_connection_confirmed():
	print(" connection confirmed...")


func _on_connection_aborted():
	print(" connection aborted...")


func _on_ConnectionTime_timeout():
	MainPanel.show_connection_confirmation()
	$ConnectionTime.stop()
	print(" waiting for confirmation...")
	pass # Replace with function body.

extends Node

export(NodePath) var connection_main_panel_path
var connection_main_panel

#var ble_service = "fc9f0a57-7ccb-458c-8caf-52d28befde93"
# MAY 10, VALERIO: è il GENERAL_SERVICE_UIID definito in Bluetooth_Lokahi.h 
var ble_service = "4fafc201-1fb5-459e-8fcc-c5c9c331914b"

var command_characteristic = "1a33e440-fa7f-48ec-b887-f99663a70f58"


#---------------------------------------------------------------------------------------------------
# Called when the node enters the scene tree for the first time.
func _ready():
	connection_main_panel = get_node(connection_main_panel_path)
	# Connects signals coming from Android Bluetooth to function of this script
	# BleManager is the Android Bluetooth Plugin manager that receives and send 
	# notifications to Android 
	BleManager.connect("ble_initialized", self,"_on_ble_initialized")
	BleManager.connect("device_connected", self, "_on_device_connected")
	BleManager.connect("device_disconnected", self, "_on_device_disconnected")
	BleManager.connect("characteristic_written", self, "_on_characteristic_written")
	BleManager.initialize()
	
#---------------------------------------------------------------------------------------------------
# this function is called when Android BluetoothLE has been initialized 
func _on_ble_initialized():
	print("ble initialized")

	# connects the deivce found event of Bluetooth to the _on_dev_found function
	BleManager.connect("device_found", self, "_on_dev_found")
	BleManager.add_scan_filter_service(ble_service)

	# we use a timer to delay the start scan procedure of 1 second
	# see _on_Timer_timeout() function for the start scan procedure
	$StartBLEScan_Timer.start()


#---------------------------------------------------------------------------------------------------
# StartBLEScan_Timer (Child of MainCode node in the scene) is a timer to
# delay BLE scanning and to allow the graphical system to properly load fonts
# Without this timer the device list will show garbage characters 
func _on_Timer_timeout():
	BleManager.start_scan()


#---------------------------------------------------------------------------------------------------
# Function called when BLE scanning finds a new device
func _on_dev_found(name, address):
	connection_main_panel.add_device_item(name, address)


#---------------------------------------------------------------------------------------------------
# this function is called when BleManager has successfully connected to a device
# the device lights up and we ask confirmation for this connection
func _on_device_connected(dev_address, name):
	# we save the connected device name and adress to have them always available
	BleManager.connected_dev_address = dev_address
	BleManager.connected_dev_name = name
	print("[ConnectionScene][_on_device_connected] Connected to: "+ name)
	
	# we show the connection confirmation dialog
	connection_main_panel.show_connection_confirmation()


#---------------------------------------------------------------------------------------------------
# we have been disconnected from device
func _on_device_disconnected(dev_address, name):
	BleManager.connected_dev_name = ""
	BleManager.connected_dev_address = ""


#---------------------------------------------------------------------------------------------------
func _on_ConnectionMainPanel_connection_request(address):
	BleManager.connect_to_device_address(address)


#---------------------------------------------------------------------------------------------------
func _on_ConnectionMainPanel_connection_confirmed():
	print("[DEBUG][ConnectionScene.gd][_on_connectionMainPanel_confirmed()]Turning off LOKAHI identification lights!")
	
	# switching to main scene happens when the following command characteristic
	# has been notified. See next function _on_characteristic_written	
	
	#COMMENTATO 9 MAGGIO; DA SCOMMENTARE!
	# la linea sottostante invia all'esp32, che è stato precedentemente selezionato dalla lista
	# dei dispositivi disponibili e che, come PLUSME, dovrebbe "brillare", il comando
	# "Id0" che significa: spegniti
	BleManager.write_string_characteristic(BleManager.connected_dev_address, command_characteristic, "Id0")	
	
	# TEST 9 MAGGIO: questa if è da levare!
	# serve solo a testare che, una volta che l'ESP32 è stato selezionato e si è dato il comando di connessione,
	# si passi alla scena root.tscn.
	# Il passaggio alla scena principale dovrebbe in realtà avvenire nella funzione 
	# sottostante "on_charachteristics_written"
	#if BleManager.connected_dev_name=="Lokhai":
	#	BleManager.goto_scene("res://Scenes/root.tscn")

#---------------------------------------------------------------------------------------------------
# after connection confirmation, we have turned off identification light,
# now we can go to the main scene
func _on_characteristic_written(address, uuid):
	if uuid==command_characteristic:
		print("[DEBUG][ConnectionScene.gd]_on_charachteristic_written(): going to MainScene")
		if BleManager.connected_dev_name=="PlusMe":
			BleManager.goto_scene("res://Scenes/PlusMeMainScene/PlusMe_MainScence.tscn")
		if BleManager.connected_dev_name=="Octopus":
			BleManager.goto_scene("res://Scenes/OctopusMainScene/Octopus_MainScence.tscn")
		if BleManager.connected_dev_name=="ECHO":
			BleManager.goto_scene("res://Scenes/LokahiMainScene/Lokahi_MainScene.tscn")
			


#---------------------------------------------------------------------------------------------------
func _on_ConnectionMainPanel_connection_aborted():
	print("Disconnecting")
	#BleManager.write_byte_characteristic(dev_address, identificationChar, 0)
	BleManager.disconnect_device(BleManager.connected_dev_address)

#---------------------------------------------------------------------------------------------------

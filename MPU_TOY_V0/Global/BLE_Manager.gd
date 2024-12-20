extends Node

var ble
signal device_found(name, address)
signal device_connected(address, name)
signal device_disconnected(address, name)
signal characteristic_read(address, uuid, value)
signal characteristic_written(address, uuid)
signal characteristic_changed(address, uuid, value)
signal service_discovery_success(address)
signal connection_error(error_message, address)
signal mtu_changed(mtu)
signal ble_initialized()

var connected_dev_address
var connected_dev_name

func _on_device_found(name, address):
	emit_signal("device_found", name, address)
	
func _on_device_connected(address, name):
	emit_signal("device_connected", address, name)
	
func _on_device_disconnected(address, name):
	emit_signal("device_disconnected", address, name)

func _on_characteristic_written(address, uuid):
	emit_signal("characteristic_written", address, uuid)

func _on_characteristic_read(address, uuid, value):
	emit_signal("characteristic_read", address, uuid, value)
	
func _on_characteristic_changed(address, uuid, value):
	emit_signal("characteristic_changed", address, uuid, value)
	
func _on_discovery(address):
	emit_signal("service_discovery_success", address)

func _on_ble_initialized():
	emit_signal("ble_initialized")

func _on_mtu_changed(mtu):
	emit_signal("mtu_changed",mtu)
	
func _on_connection_error(error_message, address):
	emit_signal("connection_error", error_message, address)

var current_scene = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func initialize():
	if Engine.has_singleton("BLEPlugin"):
		print("Plugin trovato")
		print("[DEBUG][BLE_Manager.gd][initialise()]: found BLEPlugin!")
		ble = Engine.get_singleton("BLEPlugin")
		ble.connect("device_found", self, "_on_device_found")
		ble.connect("device_connected", self, "_on_device_connected")
		ble.connect("device_disconnected", self, "_on_device_disconnected")
		ble.connect("characteristic_read", self, "_on_characteristic_read")
		ble.connect("characteristic_written", self, "_on_characteristic_written")
		ble.connect("characteristic_changed", self, "_on_characteristic_changed")
		ble.connect("service_discovery_success", self, "_on_discovery")
		ble.connect("ble_initialized", self, "_on_ble_initialized")
		ble.connect("mtu_changed", self, "_on_mtu_changed")
		ble.connect(("connection_error"), self, "_on_connection_error")
		ble.initialize()

func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.free()
	
	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instance()
	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)


func add_scan_filter_dev_name(device_name):
	ble.addScanFilterDeviceName(device_name)
	
func add_scan_filter_dev_address(device_address):
	ble.addScanFilterDeviceAddress(device_address)

func add_scan_filter_service(service_uuid):
	ble.addScanFilterService(service_uuid)
	
func reset_scan_filters():
	ble.resetScanFilters()
	
func start_scan():
	ble.startScan()
	
func stop_scan():
	ble.stopScan()
	
func connect_to_device_address(device_address):
	ble.connectToDeviceByAddress(device_address)
	
func connect_to_device_name(device_name):
	ble.connectToDeviceByName(device_name)

func request_mtu(device_address):
	ble.requestMtu(device_address)
	
func disconnect_device(device_address):
	ble.disconnect(device_address)
	
func is_connected_device(device_address):
	ble.isConnected(device_address)
	
func has_service(device_address, uuid):
	ble.hasService(device_address, uuid)
	
func has_characteristic(device_address, uuid):
	ble.hasCharacteristic(device_address, uuid)
	
func set_notifications(device_address, uuid, enable):
	ble.setCharacteristicNotifications(device_address, uuid, enable)
	
func write_int_characteristic(device_address, uuid, value):
	ble.writeIntCharacteristic(device_address, uuid, value)
	
func write_byte_characteristic(device_address, uuid, value):
	ble.writeByteCharacteristic(device_address, uuid, value)
	
func write_string_characteristic(device_address, uuid, value):
	print("[DEBUG][BLE_Manager.gd][write_string_characteristic()]")
	ble.writeStringCharacteristic(device_address, uuid, value)
	
func write_float_characteristic(device_address, uuid, value):
	ble.writeFloatCharacteristic(device_address, uuid, value)
	
func read_characteristic(device_address, uuid):
	ble.readCharacteristic(device_address, uuid)
	
func is_writable(device_address, uuid):
	ble.isWritable(device_address, uuid)
	
func is_writable_no_response(device_address, uuid):
	ble.isWritableNoResponse(device_address, uuid)

func is_readable(device_address, uuid):
	ble.isReadable(device_address, uuid)
	
func is_notifiable(device_address, uuid):
	ble.isNotifiable(device_address, uuid)
	
func is_indicatable(device_address, uuid):
	ble.isIndicatable(device_address, uuid)

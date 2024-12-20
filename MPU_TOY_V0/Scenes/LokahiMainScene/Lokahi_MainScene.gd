extends Control

#per salvare il file
var log_filename = ""
var registra = false

var rng = RandomNumberGenerator.new() 

#this UUID must coincide with the
# Arduino sketch code
# MAY 10 [VALERIO]: this is the number defined in the BLECharacteristic logCharatcheristics
var logCharachteristicsUUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8"
var command_characteristic = "1a33e440-fa7f-48ec-b887-f99663a70f58"
var string_stream_characteristic = "be90e30f-4cf7-4c98-9de7-e20df844156e"
#variabili di eulero mostrate a display e monitor dati eulero e accelerometri
export (NodePath) var Eulerx_path
export (NodePath) var Eulery_path
export (NodePath) var Eulerz_path
#export (NodePath) var timer_path
export (NodePath)  var monitor_path

export (NodePath)  var monitorSynch_path

export (NodePath) var Button_airplane_path
export (NodePath) var Button_car_path
export (NodePath) var Button_walking_path
export (NodePath) var Button_ignoring_path
export (NodePath) var cbs_1_path
export (NodePath) var cbs_2_path
export (NodePath) var cbs_3_path
export (NodePath) var cbs_4_path
export (NodePath) var cbs_5_path

export (NodePath) var slidervolume_path
export (NodePath) var sliderlight_path
# la variabile dichiarata viene esportata nell'INSPECTOR
#export (NodePath)  var test_label_13_path


# VALERIO: provo a gestire la finestra dei file
export (NodePath)  var log_files_path
export (NodePath)  var popup_delete_file_path
onready var log_files_panel = get_node(log_files_path)
onready var popup_delete_file = get_node(popup_delete_file_path)

var timer
var Eulerx
var Eulery
var Eulerz
var command
var label
var monitor
var monitorSynch

# the name Lokhai is the same used to initialise 
	# the BLE device in Arduino sketch
#var dev_name = "Lokhai"
var dev_address
var button_airplane
var button_car
var button_walking
var button_ignoring

var command_volume = 0.0
var command_light = 0.0

var total_time_ms = 0  # Contatore globale per il tempo trascorso in millisecondi
var frame_duration = 33  # 33 ms per ogni frame
var leftover_ms = 0  # Millisecondi extra che avanzano

# Called when the node enters the scene tree for the first time.
func _ready():
	Eulerx = get_node(Eulerx_path)
	Eulery = get_node(Eulery_path)
	Eulerz = get_node(Eulerz_path)
	#timer = get_node(timer_path)
	monitor = get_node(monitor_path)
	monitorSynch = get_node(monitorSynch_path)
	button_airplane = get_node(Button_airplane_path)
	button_car = get_node(Button_car_path)
	button_walking = get_node(Button_walking_path)
	button_ignoring = get_node(Button_ignoring_path)

	button_airplane.connect("pressed", self, "_on_Button_airplane_pressed")
	button_car.connect("pressed", self, "_on_Button_car_pressed")
	button_walking.connect("pressed", self, "_on_Button_walking_pressed")
	button_ignoring.connect("pressed", self, "_on_Button_ignoring_pressed")
	
	# si prende dal BLE manager l'indirizzo del lokahi colleagto
	BleManager.stop_scan()
	dev_address = BleManager.connected_dev_address
	
	#popup_delete_file.visible = true
		
	# first argument is the signal that ble can emit; 
	# second arg is the object responding to the signal;
	# third arg is the  function of the object called by the detected signal;
# warning-ignore:return_value_discarded
	BleManager.connect("device_connected", self, "_on_dev_connected")
# warning-ignore:return_value_discarded
	BleManager.connect("device_found", self, "_on_dev_found")
# warning-ignore:return_value_discarded
	BleManager.connect("device_disconnected", self, "_on_dev_disconnected")
	# connette il segnale "characteristic changed" (definito nel BLE manager)
	# alla funzione _on_changed()
# warning-ignore:return_value_discarded
	BleManager.connect("characteristic_changed", self, "_on_changed")
	
	# questa funzione attiva le notifiche per la caratteristica logCharacteristicUUID
	BleManager.set_notifications(dev_address, logCharachteristicsUUID, true)
	#porzione di codice che gestisce il popoup per la cancellazione dei file?
	# connette il segnale "delete_log_file", emesso da 
	# "FileManagementPanel"
	popup_delete_file.caller = log_files_panel
	log_files_panel.connect("delete_log_file", self, "_on_delete_file")

		
func _on_changed(address, charact_UUID, value):
	print("[Start scanning][_on_changed]receiving notification...")
	# controlliamo che sia la caratteristica che vogliamo noi
	if(charact_UUID == logCharachteristicsUUID):
		
		print("BLE DATA")
		print("address: ", address)
		print("charact_UUID: ", charact_UUID)
		
		#value is an array of bytes
		var buff = StreamPeerBuffer.new()
		buff.data_array = value
		
		var misura = buff.get_size()
		print("il buffer è di " + str(misura))
		
		var Ax = map_byte_to_acc(buff.data_array[0]) #barheart0raw
		var Ay = map_byte_to_acc(buff.data_array[1]) #barheart1raw
		var Az = map_byte_to_acc(buff.data_array[2]) #Heart_0_min_raw
		var Eulerx_data = map_byte_to_angle(buff.data_array[3])
		var Eulery_data = map_byte_to_angle(buff.data_array[4])
		var Eulerz_data = map_byte_to_angle(buff.data_array[5])
		var Gx = map_byte_to_gyro(buff.data_array[6]) 
		var Gy = map_byte_to_gyro(buff.data_array[7]) 
		var Gz = map_byte_to_gyro(buff.data_array[8]) 
		var activity = buff.data_array[9]
		var result = buff.data_array[10]

		if registra: #first 3 column tilt data, then acc data, then gyro, label and result
			total_time_ms += frame_duration + leftover_ms  # Aggiorniamo il tempo totale
			var minutes = total_time_ms / 60000  # Calcolo dei minuti
			var seconds = (total_time_ms % 60000) / 1000  # Calcolo dei secondi
			var frames = (total_time_ms % 1000) / frame_duration  # Calcolo dei frame
			# Aggiungiamo il timestamp al log
			var timestamp = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2) + ":" + str(frames).pad_zeros(2)
			log_to_file(
			timestamp +
			"\t" + str(Eulerx_data) +
			"\t" + str(Eulery_data) +
			"\t" + str(Eulerz_data) +
			"\t" + str(Ax) +
			"\t" + str(Ay) +
			"\t" + str(Az) +
			"\t" + str(Gx) +
			"\t" + str(Gy) +
			"\t" + str(Gz) +
			"\t" + str(label) +
			"\t" + str(activity) +
			"\t" + str(result))
			 #+"\n")	
			# Calcoliamo i millisecondi avanzati
			leftover_ms = total_time_ms % frame_duration
			total_time_ms -= leftover_ms  # Aggiorniamo il tempo totale escludendo l'errore

		#scrive a schermo gli angoli di eulero
		Eulerx.text = str(Eulerx_data)
		Eulery.text = str(Eulery_data)
		Eulerz.text = str(Eulerz_data)

		
		#monitor segnale raw 
		monitor.stepGraph_line1(Eulerx_data)
		monitor.stepGraph_line2(Eulery_data)
		monitor.stepGraph_line3(Eulerz_data)

	#	#questo aggiorna il monitorSync -Bar
		monitorSynch.stepGraph_line1(Gx)
		monitorSynch.stepGraph_line2(Gy)
		monitorSynch.stepGraph_line3(Gz)

	else:
		pass


func create_logfile():
	var time = OS.get_datetime()
	#log_filename = String(time.year)+"_"+String(time.month).pad_zeros(2)+"_"+String(time.day).pad_zeros(2)+"_"+String(time.hour).pad_zeros(2) +"."+String(time.minute).pad_zeros(2)+"."+String(time.second).pad_zeros(2)
	log_filename = "ECHO_" + String(time.year)+"_"+String(time.month).pad_zeros(2)+"_"+String(time.day).pad_zeros(2)+"_"+String(time.hour).pad_zeros(2) +"."+String(time.minute).pad_zeros(2)+"."+String(time.second).pad_zeros(2)
	print("...creating log file:"+log_filename)
	var log_file = File.new()

	log_file.open(OS.get_user_data_dir()+"/"+log_filename, File.WRITE)
	#var column_header = "loop_count, loop_dur, h0, h1, synch"
	#log_file.store_line(column_header)
	log_file.close()


# ho cambiato nome al tasto, ora si chiama StartLog,
# mi sa che questa funzione può essere eliminata
func _on_ButtonFile_toggled(button_pressed):
	print("Button " + str(button_pressed))
	
	if button_pressed == true:
		registra = true
	else:
		registra = false
		
		#apro la condivisione del file
		if Engine.has_singleton("GodotShare"):
			var share = Engine.get_singleton("GodotShare")
			var file_save_path = OS.get_user_data_dir() + "/" + log_filename
			share.shareTextFile(file_save_path,"Log File", "Log File", "Log file of LOKAHI")	
	pass # Replace with function body.

func log_to_file(line):
	if log_filename == "":
		create_logfile()

	var log_file = File.new()
	var filepath = OS.get_user_data_dir()
	var full_path = filepath + "/" + log_filename
	log_file.open(full_path, File.READ_WRITE)

	# Controlliamo se il file è vuoto
	if log_file.get_len() == 0:
		# Scriviamo la prima riga di intestazione
		var header = "Minutes\tSeconds\tFrames\tEulerx\tEulery\tEulerz\tAccx\tAccy\tAccz\tGyrox\tGyroy\tGyroz\tlabel\tActivity\tResult"
		log_file.store_line(header)

	log_file.seek_end()  # Ci assicuriamo di scrivere alla fine del file
	log_file.store_line(line)
	log_file.close()

#func log_to_file(line):
#	if log_filename=="":
#		create_logfile()

#	var log_file = File.new()
#	var filepath = OS.get_user_data_dir()
#	log_file.open(filepath + "/" + log_filename, File.READ_WRITE)
#	log_file.seek_end()
#	log_file.store_line(line)
#	log_file.close()

# VALERIO: it should start the record of data on file
func _on_StartLog_toggled(button_pressed):
	print("[Lokahi_MainScene][_on_StartLog_toggled] button pressed...")

	if button_pressed:
		registra = true
		command = str(10)
		BleManager.write_string_characteristic(dev_address, string_stream_characteristic, command)
		#I change the text on the button
		$SessionManagement/StartLog.text = "Stop Log"
		#VALERIO: rendo visibile o invisibile la label
		#con scritta REC. Massi ha risolto invece con
		# lo script Recording.gd (il mio è attualmente vuoto).
		$SessionManagement/Recording/LabelRec.visible=true
	else:
		registra = false
		command = str(20)
		BleManager.write_string_characteristic(dev_address, string_stream_characteristic, command)
		$SessionManagement/StartLog.text = "Start Log"
		$SessionManagement/Recording/LabelRec.visible=false
	print("Start Log pressed, registra is " + str(registra))
	
	pass # Replace with function body.

func _on_Button_airplane_pressed():
	label = str(0)
	BleManager.write_string_characteristic(dev_address, string_stream_characteristic, label)
	print("pressed_airplane")
	
func _on_Button_car_pressed():
	label = str(1)
	BleManager.write_string_characteristic(dev_address, string_stream_characteristic, label)
	print("pressed_car")

func _on_Button_walking_pressed():
	label = str(2)
	BleManager.write_string_characteristic(dev_address, string_stream_characteristic, label)


func _on_Button_ignoring_pressed():
	label = str(3)
	BleManager.write_string_characteristic(dev_address, string_stream_characteristic, label)


func _on_Files_pressed():
	print("[Lokahi_MainScene][_on_Files_pressed] button pressed...")
	log_files_panel.show()
	pass # Replace with function body.

func _on_delete_file():
	print("[Lokahi_MainScene][_on_delete_file]")
	popup_delete_file.visible = true
	pass # Replace with function body.


func map_byte_to_angle(byte_value: int) -> float:
	# Map [0, 255] byte range back to [-180, 180) degree range centered around 0
	var angle_degrees = (float(byte_value)-128) * 360.0 / 255.0
	
	# Ensure the angle is in the range [-180, 180)
	if angle_degrees < -180.0:
		angle_degrees += 360.0
	elif angle_degrees >= 180.0:
		angle_degrees -= 360.0

	return angle_degrees


func map_byte_to_acc(byte_value: int) -> float:
	
	var out_min = -2.0
	var out_max = 2.0
	var in_min = 0.0
	var in_max = 255.0
	return (byte_value - in_min) * (out_max - out_min) / (in_max - in_min) + out_min

func map_byte_to_gyro(byte_value: int) -> float:
	
	var out_min = -500.0
	var out_max = 500.0
	var in_min = 0.0
	var in_max = 255.0
	return (byte_value - in_min) * (out_max - out_min) / (in_max - in_min) + out_min


func _on_cbs_1_pressed():
	command = str(11)
	BleManager.write_string_characteristic(dev_address, string_stream_characteristic, command)


func _on_cbs_2_pressed():
	command = str(12)
	BleManager.write_string_characteristic(dev_address, string_stream_characteristic, command)


func _on_cbs_3_pressed():
	command = str(13)
	BleManager.write_string_characteristic(dev_address, string_stream_characteristic, command)


func _on_cbs_4_pressed():
	command = str(14)
	BleManager.write_string_characteristic(dev_address, string_stream_characteristic, command)


func _on_cbs_5_pressed():
	command = str(15)
	BleManager.write_string_characteristic(dev_address, string_stream_characteristic, command)

func _on_HSlider_volume_value_changed(value):
	
	command_volume = value
	BleManager.write_string_characteristic(dev_address, string_stream_characteristic, command_volume)


func _on_HSlider_light_value_changed(value):
	command_light = value
	BleManager.write_string_characteristic(dev_address, string_stream_characteristic, command_light)

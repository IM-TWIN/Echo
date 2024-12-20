extends PopupDialog


var caller
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Cancel_button_down():
	hide()
	pass # Replace with function body.


# VALERIO: il caller dovrebbe essere Lokahi Main Scene, che 
# dichiara il "popup detele file" all'inizio dello script
# FileMangementPanel ha la funzione "confirm" 
func _on_Ok_button_down():
	
	if caller.has_method("confirm"):
		caller.confirm()
	hide()
	pass # Replace with function body.

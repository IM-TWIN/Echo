extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load("res://assets/font/Agency/AGENCYB.TTF")
	dynamic_font.size = 32 # Dimensione del testo, puoi modificarla secondo le tue necessità
	
	# Applicazione del font al pulsante
	self.add_font_override("font", dynamic_font)

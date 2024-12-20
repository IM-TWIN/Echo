extends Button

export(NodePath) var info_panel_path
onready var info_panel = (get_node(info_panel_path))

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_InfoButton_pressed():
	info_panel.visible = true
	pass # Replace with function body.


func _on_Close_pressed():
	info_panel.visible = false
	pass # Replace with function body.

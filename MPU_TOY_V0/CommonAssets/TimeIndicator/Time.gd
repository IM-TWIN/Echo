extends HBoxContainer


var on = true
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reset_time():
	time = 0

func start():
	on = true
	
func stop():
	on = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if on:
		time += delta
		var format_time = "%d:%02d"
		$Time.text = format_time % [floor(time/60),int(floor(time))%60]

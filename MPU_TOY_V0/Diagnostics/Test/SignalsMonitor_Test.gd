extends Control

export(NodePath) var signal_monitor_path
var signal_monitor
var last_time=0
export var update_time=0.1
# Called when the node enters the scene tree for the first time.
func _ready():
	signal_monitor = get_node(signal_monitor_path)
	signal_monitor.initialize()

func _process(delta):
	last_time+=delta
	if last_time>update_time:
		last_time=0
		signal_monitor.stepGraph_line1(rand_range(-10,20))
		signal_monitor.stepGraph_line2(rand_range(-10,30))

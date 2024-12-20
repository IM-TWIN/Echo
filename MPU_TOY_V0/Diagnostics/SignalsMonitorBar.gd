# il mio script di prova


extends Panel

export(NodePath) var max_label_path
export(NodePath) var min_label_path

onready var max_label=get_node(max_label_path)
onready var min_label=get_node(min_label_path)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var values_line1:PoolRealArray
var values_line2:PoolRealArray
export var tickNumber=10
var tickSize
var baseline
var points_line1:PoolVector2Array
var points_line2:PoolVector2Array
var curr_max = 0.0
var curr_min = 0.0
var k_scale

#il valore attuale del sensore
var current_value_0
var current_value_1

# Called when the node enters the scene tree for the first time.
func _ready():
	points_line1.resize(tickNumber)
	points_line2.resize(tickNumber)
	values_line1.resize(tickNumber)
	values_line2.resize(tickNumber)

func initialize():
	tickSize = (rect_size.x)/(tickNumber-1)
	baseline = (rect_size.y) * .5
	for i in range(tickNumber):
		points_line1[i].x = i*tickSize
		points_line2[i].x = i*tickSize
		
	current_value_0 = 0
	current_value_1 = 0


func _process(delta):
	#stepGraph(randf()*baseline)
	#update()
	pass
	
func stepGraph_line1(newValue):

	# shift values
	for i in values_line1.size()-1:
		values_line1[i] = values_line1[i+1]
		points_line1[i].y = points_line1[i+1].y

	#add new value
	values_line1[values_line1.size()-1] = scale_value(newValue)
	points_line1[values_line1.size()-1].y = baseline - values_line1[values_line1.size()-1]
	
	
	current_value_0 = newValue
	
	update()


func stepGraph_line2(newValue):
	# shift values
	for i in values_line2.size()-1:
		values_line2[i] = values_line2[i+1]
		points_line2[i].y = points_line2[i+1].y

	# add new values
	values_line2[values_line2.size()-1]= scale_value(newValue)
	points_line2[values_line2.size()-1].y = baseline - values_line2[values_line2.size()-1]
	
	current_value_1 = newValue
	
	update()


func scale_value(value)->float:
	curr_max = curr_max if value<curr_max else value
	curr_min = curr_min if value>curr_min else value
	k_scale = rect_size.y / (curr_max-curr_min)
	baseline = k_scale * curr_max
	max_label.text =  "%.2f" %  curr_max 
	min_label.text =  "%.2f" % curr_min 
	return value*k_scale


func _draw():
	
	
	draw_line(Vector2(0, baseline), Vector2(rect_size.x, baseline),Color.white, 2)
	#draw_polyline(points_line1, Color.green, 2.0,true)
	#draw_polyline(points_line2, Color.yellow, 2.0,true)
	
	var myPos = Vector2(20, baseline - current_value_0)
	var mySize = Vector2(100, current_value_0)
	var pippo = Rect2(myPos, mySize)
	var myColor = Color(1,0,0)
	

	draw_rect(pippo, myColor)

	#secondo rettangolo accanto al primo
	var myPos1 = Vector2(20 + pippo.size.x + 20, baseline - current_value_1)
	var mySize1 = Vector2(100, current_value_1)
	var pippo1 = Rect2(myPos1, mySize1)
	var myColor1 = Color(0,0.5,1)
	
	draw_rect(pippo1, myColor1)

	#for i in range(tickNumber):
	#	draw_line(Vector2(i*tickSize,baseline-values[i]), Vector2(tickSize*(i+1),baseline-values[i+1]), Color.green, 2.0,true)
	pass



func _on_LegMonitor_resized():
	initialize()
	pass # Replace with function body.

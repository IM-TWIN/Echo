extends Panel

export(NodePath) var max_label_path
export(NodePath) var min_label_path
onready var max_label=get_node(max_label_path)
onready var min_label=get_node(min_label_path)

export(Color) var mainLineColor


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var values_line1:PoolRealArray
var values_line2:PoolRealArray
var values_line3:PoolRealArray
var values_line4:PoolRealArray


export var tickNumber=10
var tickSize
var baseline
var points_line1:PoolVector2Array
var points_line2:PoolVector2Array
var points_line3:PoolVector2Array
var points_line4:PoolVector2Array
var curr_max = 255.0
var curr_min = 0.0
var k_scale

# Called when the node enters the scene tree for the first time.
func _ready():
	points_line1.resize(tickNumber)
	points_line2.resize(tickNumber)
	points_line3.resize(tickNumber)
	points_line4.resize(tickNumber)
	values_line1.resize(tickNumber)
	values_line2.resize(tickNumber)
	values_line3.resize(tickNumber)
	values_line4.resize(tickNumber)

func initialize():
	tickSize = (rect_size.x)/(tickNumber-1)
	baseline = (rect_size.y) * .5
	for i in range(tickNumber):
		points_line1[i].x = i*tickSize
		points_line2[i].x = i*tickSize
		points_line3[i].x = i*tickSize
		points_line4[i].x = i*tickSize


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
	update()


func stepGraph_line2(newValue):
	# shift values
	for i in values_line2.size()-1:
		values_line2[i] = values_line2[i+1]
		points_line2[i].y = points_line2[i+1].y

	# add new values
	values_line2[values_line2.size()-1]= scale_value(newValue)
	points_line2[values_line2.size()-1].y = baseline - values_line2[values_line2.size()-1]
	update()

func stepGraph_line3(newValue):
	# shift values
	for i in values_line3.size()-1:
		values_line3[i] = values_line3[i+1]
		points_line3[i].y = points_line3[i+1].y

	# add new values
	values_line3[values_line3.size()-1]= scale_value(newValue)
	points_line3[values_line3.size()-1].y = baseline - values_line3[values_line2.size()-1]
	update()

func stepGraph_line4(newValue):
	# shift values
	for i in values_line4.size()-1:
		values_line4[i] = values_line4[i+1]
		points_line4[i].y = points_line4[i+1].y

	# add new values
	values_line4[values_line4.size()-1]= scale_value(newValue)
	points_line4[values_line4.size()-1].y = baseline - values_line4[values_line2.size()-1]
	update()


func scale_value(value)->float:
	# I want the scale fixed in [0,255]
	curr_max = 255 #curr_max if value<curr_max else value
	curr_min = 0 #curr_min if value>curr_min else value
	k_scale = rect_size.y / (curr_max-curr_min)
	baseline = k_scale * curr_max
	max_label.text =  "%.2f" %  curr_max 
	min_label.text =  "%.2f" % curr_min 
	return value*k_scale


func _draw():
	#draw_line(Vector2(0, baseline), Vector2(rect_size.x, baseline),Color.white, 2)
	
	#cuore
	#draw_polyline(points_line1, Color(1.0, 0.0, 0.0), 4.0,true)
	draw_polyline(points_line1, mainLineColor, 4.0,true)
	
	
	# valore min
	draw_polyline(points_line2, Color(1, 1, 0.0 ), 1.0,true)
	
	#valore max
	draw_polyline(points_line3, Color(0.0, 1.0, 0.0 ), 1.0,true)
	
	# valore thresh
	draw_polyline(points_line4, Color(1.0, 1.0, 1.0 ), 1.0,true)
	#for i in range(tickNumber):
	#	draw_line(Vector2(i*tickSize,baseline-values[i]), Vector2(tickSize*(i+1),baseline-values[i+1]), Color.green, 2.0,true)
	
	
	
	pass



func _on_LegMonitor_resized():
	initialize()
	pass # Replace with function body.
